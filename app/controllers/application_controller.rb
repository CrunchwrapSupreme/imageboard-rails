class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :users_comment?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_back_or_to root_url, alert: exception.message, status: :see_other
  end

  protected

  def users_comment?(comment)
    if !comment.anonymous?
      comment.user.eql?(current_user)
    else
      false
    end
  end

  def current_anon_name
    return if current_user

    if session[:anon_name].nil? || session[:anon_name]&.length != 12 ||
       session[:anon_time].nil? || session[:anon_time] < Time.current - 1.day
      session[:anon_name] = SecureRandom.hex(6)
      session[:anon_time] = Time.current
    end
    session[:anon_name]
  end
end
