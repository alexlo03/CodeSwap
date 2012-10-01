class ApplicationController < ActionController::Base
  rescue_from ActionController::RoutingError, :with => :render_404
  protect_from_forgery
  def not_found
    raise ActionController::RoutingError.new('Page Not Found. Please contact the system administrator.')
  end
end
