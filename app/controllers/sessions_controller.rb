class SessionsController < ApplicationController
  skip_before_filter :authorize

  def login
    @user = User.new
  end

  def create
    @user = User.find_by(name: params[:user][:name].downcase)
    if @user and @user.authenticate(params[:user][:password])
      session[:user_name] = @user.name
      redirect_to posts_url
    else
      redirect_to login_url, alert: "Неверная пара логин/пароль"
    end
  end

  def destroy
    session[:user_name] = nil
    redirect_to posts_url
  end
end
