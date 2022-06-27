class ApplicationController < ActionController::Base
  helper_method :current_anon_name, :users_comment?

  protected

  def users_comment?(comment)
    if comment.anonymous?
      comment.anon_name.eql?(current_anon_name)
    else
      comment.user.eql?(current_user)
    end
  end

  def has_roles?(user:, board:)
    current_user&.min_role?(user) || current_board&.min_role?(current_user, board)
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

  def current_board
    @board ||= Board.find_by(short_name: params[:board_short_name].downcase || params[:short_name].downcase)&.decorate
  end

  def unauthorized!
    byebug
    redirect_to root_url, alert: 'Unauthorized'
  end
end
