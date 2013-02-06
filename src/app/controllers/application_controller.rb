class ApplicationController < ActionController::Base
include ApplicationHelper
  rescue_from ActionController::RoutingError, :with => :render_404
	rescue_from Exception do |e|
		Emailer.delay.show_error(e)
		raise e
	end
  protect_from_forgery
  def not_found
    raise ActionController::RoutingError.new('Page Not Found. Please contact the system administrator.')
  end



end
