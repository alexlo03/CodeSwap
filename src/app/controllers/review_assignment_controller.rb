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
    @assignment_id = session[:assignment_id]
    @assignment = Assignment.find(@assignment_id)
    @course = @assignment.course
    @students = @course.get_students
    
    @seed = get_seed(nil)
    @depth = get_depth(nil)

    @student_pairing_hash = create_pairings(@students,@depth,@seed)
  end

end
