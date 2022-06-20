class ApplicationController < ActionController::Base

  protected

  def require_daemon
    return if current_user.min_role?(:daemon)

    unauthorized!
  end

  def require_owner
    return if current_user.min_role?(:owner)

    unauthorized!
  end

  def current_board
    @board
  end

  def unauthorized!
    flash[:danger] = 'Unauthorized'
    redirect_to root_url
  end
end
