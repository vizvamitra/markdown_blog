class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authorize

  protected
  
  def authorize
    unless User.find_by(name: session[:user_name])
      redirect_to posts_url, notice: "Доступ запрещён"
    end
  end
end
