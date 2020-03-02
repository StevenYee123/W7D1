class SessionsController < ApplicationController
  before_action :ensure_logged_in, only: [:new, :create]

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(params[:user][:username], params[:user][:password])
      
    if user
      # debugger
      login!(user)
      redirect_to cats_url
    else
      # debugger
      flash.now[:errors] = ["Invalid username or password"]
      render :new
    end
  end

  def destroy
    logout! 
    redirect_to new_session_url
  end
end