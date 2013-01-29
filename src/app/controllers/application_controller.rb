class ApplicationController < ActionController::Base
  rescue_from ActionController::RoutingError, :with => :render_404
  protect_from_forgery
  def not_found
    raise ActionController::RoutingError.new('Page Not Found. Please contact the system administrator.')
  end

  def requires(roles)
    unless current_user && roles.include?(current_user.role)
      flash[:error] = 'You do not have permission to view this page. Contact a system administrator if you think this is incorrect.'
      redirect_to root_path
    end
  end

end
