class SessionsController < ApplicationController
  before_action :already_logged_in!, except: [:destroy]

  def new
    render :new
  end

  def create
    current_user = User.find_by_credentials(
      params[:user][:user_name],
      params[:user][:password]
    )

    if current_user
      current_user.reset_session_token!
      login!(current_user)
      redirect_to cats_url
    else
      render json: "Credentials were wrong"
    end
  end

  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to new_session_url
  end

end
