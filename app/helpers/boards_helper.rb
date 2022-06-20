module BoardsHelper
  def current_board
    @board
  end

  def min_board_role?(role)
    !!current_board&.min_role?(current_user, role)
  end
end
