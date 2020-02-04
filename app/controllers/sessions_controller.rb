class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      if user.activated?
      log_in user
        if params[:session][:remember_me] == Settings.remember_me_status
        remember user
        else
        forget user
        end
      else
      message = "Account not activated."
      message += "Check your email for the activation link."
      flash[:warning] = message
      redirect_to root_path
      end
    else
      flash.now[:danger] = t ".warning"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
