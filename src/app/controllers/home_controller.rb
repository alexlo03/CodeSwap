class HomeController < ApplicationController
  def index
  end

  def contact_us
  end

  def send_contact_email
    name = params[:user_name]
    subject = params[:comment_subject]
    comment = params[:comment_text]

    Emailer.delay.file_complaint(name, subject, comment)

    flash[:notice] = 'Message received! Thank you very much for your feedback!'
    redirect_to contact_us_path
  end

end
