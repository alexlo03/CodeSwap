class Emailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.emailer.signup_confirmation.subject
  #
  def signup_confirmation(user)
  
    @user = user
    @greeting = "CodeSwap Account Created"

    mail content_type: 'text/html', to: user.email, subject: "CodeSwap Account Creation Successfully"
  end
end
