class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :authorized_owner, :authorized_owner?

  def login!(user)
    @current_user = user
    session[:session_token] = user.session_token
  end

  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by_session_token(session[:session_token])
  end

  def already_logged_in!
    redirect_to cats_url if current_user
  end

  def authorized_owner
    cat_ids = []
    cat_id = params[:id].to_i
    current_user.cats.each do |cat|
      owned_cat_id = cat.id
      cat_ids << owned_cat_id
    end
    redirect_to cats_url unless cat_ids.include?(cat_id)
  end

  def authorized_owner?
    cat_ids = []
    cat_id = params[:id].to_i
    current_user.cats.each do |cat|
      owned_cat_id = cat.id
      cat_ids << owned_cat_id
    end
    cat_ids.include?(cat_id) ? true : false
  end
end
