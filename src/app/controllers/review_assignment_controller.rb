class ReviewAssignmentController < ApplicationController
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

end
