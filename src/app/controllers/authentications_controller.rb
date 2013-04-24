## Handles OpenAuth Integration
class AuthenticationsController < ApplicationController

  ## Used to view all open authentications
  # [Route(s)]
  ## * /authentications
  ## * /authentications/index
  # [Params]
  ## * None
  # [Environment Variables]
  ## * authentications - All authentications authorized by the current user
  def index
    @authentications = current_user.authentications if current_user
  end

  ## Associates an open auth account with the user.
  ## Magic.
  # [Route(s)]
  ## * /authentications/create
  # [Params]
  ## * None
  # [Environment Variables]
  ## * None
  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, authentication.user)
    else
      if current_user
        current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
        flash[:notice] = "Authentication successful."
        redirect_to root_path
      else
        flash[:error] = "This " + omniauth['provider'] + " account is not linked yet. Please log in and link the account."
        redirect_to user_session_path
      end
    end
  end

  ## Disassociates an open authentication account with the current user.
  # [Route(s)]
  ## * /authentications/destroy/:id
  # [Params]
  ## * id - ID of the authentication to destroy
  # [Environment Variables]
  ## * authentication - instance of the destroyed authentication
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to user_session_path
  end
end
