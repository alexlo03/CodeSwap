class ApplicationController < ActionController::Base
include ApplicationHelper
  rescue_from ActionController::RoutingError, :with => :render_404
	rescue_from Exception do |e|
    email = '<User Not Signed In>'
    email = current_user.email unless current_user.nil?
		Emailer.delay.show_error(e, email)
		raise e
	end
  protect_from_forgery
  def not_found
    raise ActionController::RoutingError.new('Page Not Found. Please contact the system administrator.')
  end



end
