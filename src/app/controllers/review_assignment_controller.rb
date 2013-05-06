## Handles Review Assignments
class ReviewAssignmentController < ApplicationController
include PairingHelper

  ## Create review (swap) assignments
  # [Route(s)]
  ## * /reviewassignment/create/:assignment_id
  # [Params]
  ## * assignment_id - ID of review assignment
  ## * name - Name of the review assignment
  ## * grouped - Flag whether groupings are to be used
  ## * questions - Mapping of questions for the reviewer to answer
  ## * previous_id - Previous assignment's ID
  # [Environment Variables]
  ## * assignment_id - ID of the Assignment being linked to the Review
  ## * assignment - Assignment for which this review is being created
  ## * review_assignments - List of active review assignments

  def create
    if request.post?
		  # Handle post request
		  
		  session[:assignment_id] = params[:assignment_id]
		  zone = Time.now.zone
		  review_assignment = ReviewAssignment.new
			review_assignment.start_date = DateTime.strptime("#{params['startDate']} #{params['startTime']} #{zone}", '%m-%d-%Y %H:%M %p %Z')
			review_assignment.end_date = DateTime.strptime("#{params['endDate']} #{params['endTime']} #{zone}", '%m-%d-%Y %H:%M %p %Z')
		  review_assignment.name = params[:name]
		  review_assignment.assignment_id = params[:assignment_id]
		  review_assignment.user_id = current_user.id
		  review_assignment.course_id = Assignment.find(params[:assignment_id]).course_id
		  
		  if(params[:previous_id] != '-1')
		    review_assignment.grouped = ReviewAssignment.find(params[:previous_id]).grouped
		  else
		    review_assignment.grouped = (params[:grouped] == 'true')
		  end
		  
		  review_assignment.save
		  
		  questions = params[:questions]
      questions.each do |i,question|
        title = question[0]
        type = question[1]
        content = question[2]
        
        review_question = ReviewQuestion.new
        review_question.question_title = title
        review_question.set_type(type)
        review_question.review_assignment_id = review_assignment.id
        review_question.content = content
        review_question.save
				unless question[4].nil?
					question.last(question.length-3).each do |extra|
						QuestionExtra.create(:review_question_id => review_question.id, :extra => extra)
					end
				end
      end
			
      session[:review_assignment_id] = review_assignment.id		
      session[:previous_id] = params[:previous_id]
      session[:grouped] = (params[:grouped] =='true')
		  render :nothing => true
    else
			# Handle get request
      @assignment_id = params[:assignment_id]
      @assignment = Assignment.find(@assignment_id)
			review_assignment_already_exists = ReviewAssignment.find_by_assignment_id(@assignment_id)
			if(review_assignment_already_exists)
			  flash[:error] = 'A review assignment already exists for this assignment. Redirecting to the existing review assignment. Please contact the system administrator if you are receiving this message in error.'
			  redirect_to '/reviewassignment/view/' + review_assignment.id.to_s
			end
			review_assignments = ReviewAssignment.find_all_by_course_id(@assignment.course_id)
			ignored_assignment_pairings = review_assignments.collect(&:assignment_pairing).collect(&:previous_id)
			@review_assignments = review_assignments.drop_while{|x| x.assignment_pairing_id.in?(ignored_assignment_pairings)}
    end
  end


  ## Edit review (swap) assignments
  # [Route(s)]
  ## * /reviewassignment/edit/:assignment_id
  # [Params]
  ## * startDate - Date which the review assignment will start
  ## * startTime - Time which the review assignment will start
  ## * endDate - Date which the review assignment will end
  ## * endTime - Time which the review assignment will start
  ## * name - Name of the review assignment
  ## * grouped - Whether or not the review assignment is using
  ## * question - Mapping of questions for the reviewers to answer
  # [Environment Variables]
  ## * course - The course to which the review assignment under review belongs
  ## * review_assignment - The review assignment being edited
  ## * review_questions - Collection of questions currently part of the review assignment
  ## * review_question_choices - Collection of available answers for questions (i.e. multiple choice options {a, b, c, ....})

  def edit
    requires({'role'=>['admin', 'faculty']})
    review_assignment = ReviewAssignment.find(params[:id])
    @course = review_assignment.course
    
    
    if request.get? 
      @review_assignment = review_assignment
      @review_questions = ReviewQuestion.find_all_by_review_assignment_id(review_assignment.id)
      @review_question_choices = []
      @review_questions.each do |r|
        @review_question_choices.push(QuestionExtra.find_all_by_review_question_id(r.id).collect(&:extra))
      end
    else
    # Handle post request
		  zone = Time.now.zone
			review_assignment.start_date = DateTime.strptime("#{params['startDate']} #{params['startTime']} #{zone}", '%m-%d-%Y %H:%M %p %Z')
			review_assignment.end_date = DateTime.strptime("#{params['endDate']} #{params['endTime']} #{zone}", '%m-%d-%Y %H:%M %p %Z')
		  review_assignment.name = params[:name]
		  review_assignment.grouped = (params[:grouped]=='true')
		  review_assignment.save
		  
		  old_questions = ReviewQuestion.find_all_by_review_assignment_id(review_assignment.id)
		  old_questions.each{|q| q.destroy }
		  
		  questions = params[:questions]
      questions.each do |i,question|
        title = question[0]
        type = question[1]
        content = question[2]
        review_question = ReviewQuestion.new
        review_question.question_title = title
        review_question.set_type(type)
        review_question.review_assignment_id = review_assignment.id
        review_question.content = content
        review_question.save
				unless question[4].nil?
					question.last(question.length-3).each do |extra|
						QuestionExtra.create(:review_question_id => review_question.id, :extra => extra)
					end
        end
      end
      flash[:notice] = "Review Assignment Updated Successfully!"
      
    end
    @review_assignment = review_assignment
    
  end


  ## Match users to reviewers
  # [Route(s)]
  ## /reviewassignment/pairings/
  ## /reviewassignment/pairings/1
  # [Params]
  ## * redo - flag for reassigning pairings
  # [Session Variables]
  ## * assignment_id - ID of the assignment linked to the review being created
  ## * review_assignment_id - The ID of the review assignment for which pairings are being generated
  ## * seed - seed used for randomization of pairings on this assignment
  ## * depth - number of assignments in the "assignment link" chain
  ## * student_pairing_hash - 
  # [Environment Variables]
  ## * assignment_id - ID of assignment to which the review is linked.
  ## * assignment - Assignment to which the review is link
  ## * course - The course to which the review assignment under review belongs
  ## * students - Collection of all students in course
  ## * review_assignment_id - current review assignment's as
  ## * prev_id - ID of previous assignment (most recelinked assignment)
  ## * seed - seed used for randomization of pairings on this assignment
  ## * depth - number of assignments in the "assignment link" chain
  ## * student_pairing_hash - hash of student pairing informa

  def pairings
			@assignment_id = session[:assignment_id]
			@assignment = Assignment.find(@assignment_id)
			@course = @assignment.course
			@students = @course.get_students
			@review_assignment_id = session[:review_assignment_id]
		# Handle post request
		if request.post?
		  review_assignment = ReviewAssignment.find(@review_assignment_id)
			pairing = AssignmentPairing.new
			pairing.seed = session['seed']
			pairing.depth = session['depth']
		  pairing.previous_id = session[:previous_id].to_i
			pairing.save
			review_assignment.assignment_pairing_id = pairing.id
			review_assignment.save      

			
			if review_assignment.grouped?
				groups = @assignment.course.get_groups
				#Assuming 2 groups...
				hash = pair(groups[0],groups[1],pairing.seed,pairing.depth,@assignment.course.user.id)
			else
				hash = create_pairings(@students,pairing.depth,pairing.seed)
			end
			hash.each do |key, val|
				key.each do |user_1_id|
					val.each do |user_2_id|
						ReviewMapping.create(:user_id => user_1_id, :other_user_id => user_2_id, :review_assignment_id => review_assignment.id)
					end
				end
			end
			render :nothing => true
			
		else		
			unless params[:redo].nil?
				session['seed'] = nil
				session['depth'] = nil
			end
			#Handle get request
			@prev_id = session[:previous_id].to_i
			log = Logger.new("testin2.log")
			log.warn @prev_id
			log.warn @prev_id.nil? 
			log.warn @prev_id == -1
			if ((@prev_id.nil?) or (@prev_id == -1))
				log.warn "made it"
				@prev_id = nil
			end
			if session['seed'].nil?
				@seed = get_seed(@prev_id)
				@depth = get_depth(@prev_id)
				session['seed'] = @seed
				session['depth'] = @depth
			else
				@seed = session['seed']
				@depth = session['depth']
			end
			
			review_assignment = ReviewAssignment.find(@review_assignment_id)
			
			if review_assignment.grouped?
				groups = @assignment.course.get_groups
				#Assuming 2 groups...
				@student_pairing_hash = pair(groups[0],groups[1],@seed,@depth,@assignment.course.user.id)
			else
	    	@student_pairing_hash = create_pairings(@students,@depth,@seed)
			end
		end
  end


  ## Display reviews todo / feedback for the current review assignment
  # [Route(s)]
  ## * /reviewassignment/view/
  # [Params]
  ## * id - current review assignment's id
  # [Session Variables]
  ## * assignment_id - assignment to which the review assignment is linked
  ## * review_assignment_id - ID of the review assignment
  # [Environment Variables]
  ## * id - ID of the review assignment
  ## * review_assignment - the current review assignment
  ## * student - flag signifying if the user is a student
  ## * count - number of pairings a user has for the review assignment
  ## * students - collection of students with the review assignment
  ## * teacher_grades - collection of each user's reviews for the review assignment
	def view
		@id = params[:id]
		@review_assignment = ReviewAssignment.find(@id)
		unless current_user.nil?
			if @review_assignment.course.is_user_student(current_user.id)
				@student = true
				
				@reviews = ReviewMapping.find_all_by_user_id_and_review_assignment_id(current_user.id,@id)
        
			elsif current_user.faculty? || current_user.admin? || @review_assignment.course.is_user_ta(current_user.id)
				session['assignment_id'] = @review_assignment.assignment.id
				session['review_assignment_id'] = @review_assignment.id
				@student = false
				@students = User.find_all_by_id(@review_assignment.course.get_students)
				@teacher_grades = ReviewMapping.find_all_by_user_id_and_review_assignment_id(current_user.id,@review_assignment.id)
			end
		end
	end


  ## Renders the current state of a user's answer form for the current review assignment
  # [Route(s)]
  ## * /reviewassignment/<review assignment ID>/<mapping_id>/answer_form
  # [Params]
  ## * id - the current review assignment's id
  ## * pos- question order
  # [Environment Variables]
  ## * id - the current review assignment's id
  ## * pos - question order
  ## * review_assignment - the current review assignment
  ## * review_mapping - mapping of reviewers to reviewees
  ## * other_id - ID of user under review
  ## * file_submission - files submitted by the reviewee
  ## * questions - questions associated with the current review assignment
  ## * extras_hash - hash of question components, such as multiple-choice options.  (sorted by key value pairs, the id is the association with a particular question)
  ## * answers_hash - answers for each question

	def answer_form
		@id = params[:id]
		@pos = params[:pos]
		
		@review_assignment = ReviewAssignment.find(@id)
		@review_mapping = ReviewMapping.find_all_by_user_id_and_review_assignment_id(current_user.id,@id)[@pos.to_i]
		@other_id = @review_mapping.other_user_id
		
		@file_submission = @review_assignment.find_file_submission(@review_mapping.other_user_id)
		@questions = ReviewQuestion.find_all_by_review_assignment_id(@id)
		
		
		answers = ReviewAnswer.find_all_by_review_question_id_and_user_id_and_other_id(@questions.collect(&:id), current_user.id, @review_mapping.other_user_id)
		
		@extras_hash = Hash.new
		
		@answers_hash = Hash.new
		
		@questions.each do |question|
			@extras_hash[question.id] = question.question_extras
		  review_answer = answers.select{|ans| ans.review_question_id.eql? question.id}.first
		  
		  if review_answer.nil?
		    review_answer = ''
		  else
		    review_answer = review_answer.answer
		  end
		  
		  @answers_hash[question.id] = review_answer
		end
	end


  ## Submits a student's review
  # [Route(s)]
  ## * Post Request Page
  # [Params]
  ## * answers - user's answers to review questions
  ## * other_id - reviewee's ID
  ## * id - current review assignment's ID
  # [Environment Variables]
  ## * NONE
	def student_submit
		if request.post?
			answers = params[:answers]
			other_id = params[:other_id]
			review_assignment = ReviewAssignment.find(params[:id])
			questions = review_assignment.review_questions
			user_id = current_user.id
			answers.each_with_index do |answer, i|
			  review_question = questions[i]
			  old_answer = ReviewAnswer.find_by_review_question_id_and_user_id_and_other_id(review_question.id, user_id, other_id)
			  if(old_answer.nil?)
				  ReviewAnswer.create(:user_id => user_id, :review_question_id => questions[i].id, :answer => answer, :other_id => other_id)
			  else	
			    old_answer.answer = answer
			    old_answer.save
			  end
			end
			flash[:notice] = "Thanks for your review! Your answers have been saved. You may go back at any time (before #{review_assignment.pretty_end_date}) to change your answers."
			render :nothing => true
		end
	end

  ## Allows faculty to view reviews of students
  # [Route(s)]
  ## * /reviewassignment/viewsubmission/<mapping id>
  # [Params]
  ## * mapping_id - ID of the currently mapped review
  # [Environment Variables]
  ## * student_a - reviewer
  ## * student_b - reviewee
  ## * review_assignment - mapping of reviewers to reviewees for current review assignment
  ## * answers - student_a's reviews (answers) of student_b
	def view_submission
		mapping = ReviewMapping.find(params[:mapping_id])
		@student_a = mapping.user
		@review_assignment = mapping.review_assignment
		@student_b = mapping.other_user
		@answers = ReviewAnswer.find_all_by_user_id_and_other_id(@student_a.id, @student_b.id)
		@answers = @answers.reject{|x| x.review_question.review_assignment.id != @review_assignment.id}
		
	end

  ## Generates a grade report for the review assignment.
  # [Route(s)]
  ## * /reviewassignment/1/grades.<html, xls, csv>
  # [Params]
  ## * id - the current review assignment's ID
  # [Environment Variables]
  ## * mappings - all review mappings for the review assignment
  ## * questions - all questions for the review assignment
  ## * answers - all reviews submitted for the review assignment
	def grades
		id = params[:id]
		@mappings = ReviewMapping.find_all_by_review_assignment_id(id)
		@questions = ReviewQuestion.find_all_by_review_assignment_id(id)
		@answers = {}
		@mappings.each do |mapping|
			@answers[mapping.id] = ReviewAnswer.order(:review_question_id).find_all_by_user_id_and_other_id_and_review_question_id(mapping.user_id,mapping.other_user_id,@questions.collect(&:id))
		end
		respond_to do |format|
			format.html
			format.xls
			format.csv {send_data ReviewAssignment.find(id).to_csv(@mappings,@questions,@answers) }
		end
		
	end

  ## Allows a reviewee to see its reviews.
  # [Route(s)]
  ## * /reviewassignment/view_feedback/<review_assignment.id>
  # [Params]
  ## * id - the current review assignment's ID
  # [Environment Variables]
  ## * review assignment - the current review assignment
  ## * past_due - whether the Review was submitted past the due date
  ## * questions - all questions for the review assignment
  ## * answers -  all reviews of the current user's for the current review assignment
	def view_feedback
		unless current_user.nil?
			review_assignment_id = params[:id]
			@review_assignment = ReviewAssignment.find(review_assignment_id)
			@past_due = @review_assignment.end_date <= DateTime.now
			@questions = ReviewQuestion.find_all_by_review_assignment_id(review_assignment_id)
			@answers = Hash.new
			user_id = current_user.id
			@questions.each do |question|
				@answers[question.id] = ReviewAnswer.find_all_by_review_question_id_and_other_id(question.id,user_id,user_id)
			end
		end
	end
end
