class UsersController < ApplicationController
  before_action :already_logged_in!
  def new
    render :new
  end

  def create
    @user = User.new(user_params)

    # fail
    if @user.save
      login!(@user)
      redirect_to cats_url
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to new_user_url
    end

  end

  def show
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
