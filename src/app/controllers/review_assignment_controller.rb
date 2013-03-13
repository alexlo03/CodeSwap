class ReviewAssignmentController < ApplicationController
include PairingHelper
  
  def create
    if request.post?
		  # Handle post request
     	session[:startDate] = params[:startDate]
		  session[:endDate] = params[:endDate]
     	session[:startTime] = params[:startTime]
		  session[:endTime] = params[:endTime]
		  session[:name] = params[:name]
		  session['questions'] = params['questions']
		  session[:assignment_id] = params[:assignment_id]
			session[:prev_id] = params[:previous_id].to_i
			
      session[:grouped] = (params[:grouped]=='true')
			
			
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
		# Handle post request
		if request.post?
			review_assignment = ReviewAssignment.new
			pairing = AssignmentPairing.new
			pairing.seed = session['seed']
			review_assignment.start_date = Date.strptime("#{session['startDate']} #{session['startTime']}", '%m-%d-%Y %H:%M %p')
			review_assignment.end_date = Date.strptime("#{session['endDate']} #{session['endTime']}", '%m-%d-%Y %H:%M %p')
			review_assignment.assignment_id = session['assignment_id']
			review_assignment.name = session['name']
			review_assignment.course_id = review_assignment.assignment.course.id
			review_assignment.grouped = session[:grouped]
			pairing.depth = session['depth']
      questions = session['questions']
			pairing.save
			review_assignment.assignment_pairing_id = pairing.id
			review_assignment.user_id = current_user.id
			review_assignment.save      
      split_string = '~`~`~'
      questions.each do |question|
        title = question.split(split_string)[0]
        type = question.split(split_string)[1]
        content = question.split(split_string)[2]
        

        review_question = ReviewQuestion.new
        review_question.question_title = title
        review_question.set_type(type)
        review_question.review_assignment_id = review_assignment.id
        review_question.content = content
        review_question.save
      end
			
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
			if session[:grouped]
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

	def answer_forum
		@id = params[:id]
		@pos = params[:pos]
		@review_assignment = ReviewAssignment.find(@id)
		@review_mapping = ReviewMapping.find_all_by_user_id_and_review_assignment_id(current_user.id,@id)[@pos.to_i]
		@other_id = @review_mapping.other_user_id
		@file_submission = @review_assignment.find_file_submission(@review_mapping.other_user_id)
		@questions = ReviewQuestion.find_all_by_review_assignment_id(@id)
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
