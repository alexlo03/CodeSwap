class HomeController < ApplicationController


  ## TODO DOCUMENT
  ## PURPOSE
  # [Route(s)]
  ## * TODO define routes
  # [Params]
  ## * TODO define params
  # [Environment Variables]
  ## * TODO define environment variables
  def index

  end


  ## TODO DOCUMENT
  ## PURPOSE
  # [Route(s)]
  ## * TODO define routes
  # [Params]
  ## * TODO define params
  # [Environment Variables]
  ## * TODO define environment variables
  def contact_us
  end


  ## TODO DOCUMENT
  ## PURPOSE
  # [Route(s)]
  ## * TODO define routes
  # [Params]
  ## * TODO define params
  # [Environment Variables]
  ## * TODO define environment variables
  def send_contact_email
    name = params[:user_name]
    subject = params[:comment_subject]
    comment = params[:comment_text]

    if comment == ''
      flash[:error] = 'Please enter content to the comment section before submitting. Thanks!'
    else
      Emailer.delay.file_complaint(name, subject, comment)
      flash[:notice] = 'Message received! Thank you very much for your feedback!'
    end
    redirect_to contact_us_path
  end

end
