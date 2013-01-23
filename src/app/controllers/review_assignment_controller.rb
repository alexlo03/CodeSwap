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
			@review_assignments = ReviewAssignment.where(:course_id => Assignment.find(params[:assignment_id]).course.id)
    end
		
  end

  def pairings
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
			render :nothing => true

		else		
			unless params[:redo].nil?
				session['seed'] = nil
				session['depth'] = nil
			end
			#Handle get request
			@assignment_id = session[:assignment_id]
			@assignment = Assignment.find(@assignment_id)
			@course = @assignment.course
			@students = @course.get_students
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
end
