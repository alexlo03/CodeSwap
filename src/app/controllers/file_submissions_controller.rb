class FileSubmissionsController < ApplicationController

 def create
    @submission = FileSubmission.new(params[:file_submission])
    if @submission.save
      respond_to do |format|
        format.html {  
          render :json => [@submission.to_jq_upload].to_json, 
          :content_type => 'text/html',
          :layout => false
        }
        format.json {  
          render :json => [@submission.to_jq_upload].to_json			
        }
      end
    else 
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end


end
