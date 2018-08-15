class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :user_signup, :user_login, :require_login, :admin_user?

  def current_user
    if session[:user_id]
      @user ||= User.find(session[:user_id])
    end
  end

  def logged_in?
    current_user != nil
  end

  def user_signup
    @user = User.new do |u|
     u.name = params[:user]['name']
     u.height = params[:user]['height']
     u.happiness = params[:user]['happiness']
     u.nausea = params[:user]['nausea']
     u.tickets = params[:user]['tickets']
     u.admin = params[:user]['admin']
     u.password = params[:user]['password']
    end
   if @user.save
     session[:user_id] = @user.id
     redirect_to user_path(@user)
   else
     render '/users/new'
   end
  end

  def user_login
    @user = User.find_by(name: params[:user][:name])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      redirect_to '/signin'
    end
  end

  def require_login
	  unless session.include? :user_id
      redirect_to '/'
      flash[:notice] = "You must login to view that page."
    end
	end

  def admin_user?
     current_user.admin
  end

end
