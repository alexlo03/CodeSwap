class ReviewAssignmentController < ApplicationController
include PairingHelper
  
  def create
    if request.post?
     session[:startDate] = params[:startDate]
     session[:endDate] = params[:endDate]
     session[:name] = params[:name]
     session[:description] = params[:description]
     session[:assignment_id] = params[:assignment_id]
    else
      @assignment_id = params[:assignment_id]
    end
		
  end

  def pairings
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
			@assignment_id = session[:assignment_id]
			@assignment = Assignment.find(@assignment_id)
			@course = @assignment.course
			@students = @course.get_students
		
			@seed = get_seed(nil)
			@depth = get_depth(nil)
			session['seed'] = @seed
			session['depth'] = @depth
	    @student_pairing_hash = create_pairings(@students,@depth,@seed)
		end
  end
end
