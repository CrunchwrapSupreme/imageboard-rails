class BoardsBaseController < ApplicationController
  def current_board
    board_short_name = params[:board_short_name]&.downcase
    board_short_name ||= params[:short_name]&.downcase
    @board ||= Board.find_by(short_name: board_short_name)
  end

  def current_thread
    raise NotImplementedError, 'Implement current_thread on controller'
  end

  def redirect_unless_board
    return if current_board

    redirect_to boards_url, alert: 'Unknown board', status: :see_other
  end

  def redirect_unless_thread
    return if current_thread

    redirect_to board_url(@board), alert: 'Unknown thread', status: :see_other
  end
end
