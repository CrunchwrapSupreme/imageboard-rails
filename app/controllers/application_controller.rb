class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :users_comment?

  protected

  def users_comment?(comment)
    if current_user
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

  def require_daemon
    return if current_user.min_role?(:daemon)

    unauthorized!
  end

  def require_owner
    return if current_user.min_role?(:owner)

    unauthorized!
  end

  def unauthorized!
    redirect_to root_url, alert: 'Unauthorized'
  end

  def current_board
    board_short_name = params[:board_short_name]&.downcase
    board_short_name ||= params[:short_name]&.downcase
    @board ||= Board.find_by(short_name: board_short_name)&.decorate
  end

  def roles?(user:, board:)
    current_user&.min_role?(user) || current_board&.min_role?(current_user, board)
  end

  def require_daemon_or_board_mod
    unauthorized! unless roles?(user: :daemon, board: :moderator)
  end

  def require_daemon_or_board_owner
    unauthorized! unless roles?(user: :daemon, board: :owner)
  end

  def redirect_unless_daemon_or_board_admin
    unauthorized! unless roles?(user: :daemon, board: :admin)
  end
end
