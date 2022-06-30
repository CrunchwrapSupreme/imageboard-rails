class BoardsBaseController < ApplicationController
  def current_thread
    raise NotImplementedError, 'Implement current_thread on controller'
  end

  def redirect_unless_board
    return if current_board

    redirect_to boards_url, alert: 'Unknown board'
  end

  def redirect_unless_thread
    return if current_thread

    redirect_to board_url(@board), alert: 'Unknown thread'
  end
end
