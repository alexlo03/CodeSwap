class FacultyController < ApplicationController

  def index
    requires ['admin', 'faculty']
    @classes = Course.all
  end

  def new_course
    requires ['admin', 'faculty']
    @course = Course.new
  end

  def add_course
    requires ['admin', 'faculty']
    cName = params[:cname]
    cTerm = params[:cterm]
    cNumber = params[:cnumber]
    cSection = params[:csection] && params[:csection].to_i
    count = Course.where(:name => cName, :term => cTerm, :course_number => cNumber, :section => cSection).count    
    c = Course.new(:name => cName, :term => cTerm, :course_number => cNumber, :section => cSection)
    if(count == 0 && c.save)
        
    else
      c["error"] = "Course Already Exists"
    end
    render :json => c.to_json
  end
    
end
