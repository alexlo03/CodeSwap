class ReviewAssignmentController < ApplicationController
include PairingHelper
  
  def create
    if request.post?
		  #Handle post request
     	session[:startDate] = params[:startDate]
		  session[:endDate] = params[:endDate]
		  session[:name] = params[:name]
		  session[:description] = params[:description]
		  session[:assignment_id] = params[:assignment_id]
			session[:prev_id] = params[:previous_id].to_i
		  render :nothing => true
		
    else
			#Handle get request
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
		#Handle post request
		if request.post?
			review_assignment = ReviewAssignment.new
			pairing = AssignmentPairing.new
			pairing.seed = session['seed']
			review_assignment.start_date = Date.strptime(session['startDate'], '%m-%d-%Y')
			review_assignment.end_date = Date.strptime(session['endDate'], '%m-%d-%Y')
			review_assignment.assignment_id = session['assignment_id']
			review_assignment.name = session['name']
			review_assignment.description = session['description']
			review_assignment.course_id = review_assignment.assignment.course.id
			pairing.depth = session['depth']
			pairing.save
			review_assignment.assignment_pairing_id = pairing.id
			review_assignment.user_id = current_user.id
			review_assignment.save
			hash = create_pairings(@students,pairing.depth,pairing.seed)
			hash.each do |user_1_id, user_2_id|
				ReviewMapping.create(:user_id => user_1_id, :other_user_id => user_2_id, :review_assignment_id => review_assignment.id)
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
	    @student_pairing_hash = create_pairings(@students,@depth,@seed)
		end
  end

	def view
		@id = params[:id]
		@review_assignment = ReviewAssignment.find(@id)
		unless current_user.nil?
			if current_user.student?
				@student = true
				@review_mapping = ReviewMapping.find_by_user_id_and_review_assignment_id(current_user.id,@id)
				@file_submission = @review_assignment.find_file_submission(@review_mapping.other_user_id)
			elsif current_user.faculty? || current_user.admin? || current_user.ta?
				@student = false
			end
		end
	end
end
