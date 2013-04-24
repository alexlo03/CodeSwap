class ApplicationController < ActionController::Base
include ApplicationHelper
  rescue_from ActionController::RoutingError, :with => :render_404
	rescue_from Exception do |e|
    email = '<User Not Signed In>'
    email = current_user.email unless current_user.nil?
		Emailer.delay.show_error(e, email)
		if Rails.env.production?
		  flash[:error] = "Something has gone wrong. A notice has been sent to the CodeSwap team. If you continue to experience this issue, please file a complaint on the Contact Us page."
                  redirect_to(root_path)
		else
		  raise e
		end

	logger = Logger.new('log/errors.log')
	e.backtrace.each{|b| logger.error b}
	end
  protect_from_forgery


  def not_found
    raise ActionController::RoutingError.new('Page Not Found. Please contact the system administrator.')
  end



end
