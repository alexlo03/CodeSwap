class ReviewAssignmentController < ApplicationController
include PairingHelper
  
  def create
    if request.post?
		  # Handle post request
		  
		  session[:assignment_id] = params[:assignment_id]
		  zone = Time.now.zone
		  review_assignment = ReviewAssignment.new
			review_assignment.start_date = Date.strptime("#{params['startDate']} #{params['startTime']} #{zone}", '%m-%d-%Y %H:%M %p %Z')
			review_assignment.end_date = Date.strptime("#{params['endDate']} #{params['endTime']} #{zone}", '%m-%d-%Y %H:%M %p %Z')
		  review_assignment.name = params[:name]
		  review_assignment.assignment_id = params[:assignment_id]
		  review_assignment.user_id = current_user.id
		  review_assignment.grouped = (params[:grouped]=='true')
		  review_assignment.course_id = Assignment.find(params[:assignment_id]).course_id
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
			@review_assignments = ReviewAssignment.where(:course_id => Assignment.find(params[:assignment_id]).course.id)
    end
  end

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
			@prev_id = session[:prev_id]
			
			if @prev_id.nil? or (@prev_id == -1)
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


	def view
		@id = params[:id]
		@review_assignment = ReviewAssignment.find(@id)
		unless current_user.nil?
			if current_user.student?
				@student = true
				@count = ReviewMapping.find_all_by_user_id_and_review_assignment_id(current_user.id,@id).count
#				@review_mapping = ReviewMapping.find_by_user_id_and_review_assignment_id(current_user.id,@id)
#				@file_submission = @review_assignment.find_file_submission(@review_mapping.other_user_id)
#				@questions = ReviewQuestion.find_all_by_review_assignment_id(@id)
#				@done = ReviewAnswer.where(:review_question_id => @questions.collect(&:id),:user_id => current_user.id).count > 0
				
			elsif current_user.faculty? || current_user.admin? || current_user.ta?
				@student = false
				@students = User.find_all_by_id(@review_assignment.course.get_students)
				@teacher_grades = ReviewMapping.find_all_by_user_id_and_review_assignment_id(current_user.id,@review_assignment.id)
			end
		end
	end

	def answer_form
		@id = params[:id]
		@pos = params[:pos]
		@review_assignment = ReviewAssignment.find(@id)
		@review_mapping = ReviewMapping.find_all_by_user_id_and_review_assignment_id(current_user.id,@id)[@pos.to_i]
		@other_id = @review_mapping.other_user_id
		@file_submission = @review_assignment.find_file_submission(@review_mapping.other_user_id)
		@questions = ReviewQuestion.find_all_by_review_assignment_id(@id)
		@extras_hash = Hash.new
		@questions.each do |q|
			@extras_hash[q.id] = q.question_extras
		end
		@done = ReviewAnswer.where(:review_question_id => @questions.collect(&:id),:user_id => current_user.id,:other_id => @review_mapping.other_user_id).count > 0
	end

	def student_submit
		if request.post?
			answers = params[:answers]
			other_id = params[:other_id]
			review_assignment = ReviewAssignment.find(params[:id])
			questions = review_assignment.review_questions
			user_id = current_user.id
			answers.each_with_index do |answer, i|
				ReviewAnswer.create(:user_id => user_id, :review_question_id => questions[i].id, :answer => answer, :other_id => other_id)	
			end
			flash[:notice] = "Thanks for your review!"
			render :nothing => true
		end
	end

	def view_submission
		mapping = ReviewMapping.find(params[:mapping_id])
		@student_a = mapping.user
		@review_assignment = mapping.review_assignment
		@student_b = mapping.other_user
		@answers = ReviewAnswer.find_all_by_user_id_and_other_id(@student_a.id, @student_b.id)
		@answers = @answers.reject{|x| x.review_question.review_assignment.id != @review_assignment.id}
		
	end

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
end
