## Used to redirect on 404 error.
class ErrorsController < ApplicationController
  ## Used to redirect on 404 error.
  def routing
   render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end
