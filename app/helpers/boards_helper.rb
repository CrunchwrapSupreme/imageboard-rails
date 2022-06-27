module BoardsHelper
  def current_board
    @board
  end

  def min_board_role?(role)
    !!current_board&.min_role?(current_user, role)
  end

  def thumbnail_for(comment:, board:)
    content = image_tag(comment.image(:medium).url, class: ['thumbnail']) if comment.image
    content ||= "Thread #{comment.comment_thread.id}"
    thread_link(comment: comment, board: board, content: content, css: ['thumbnail'])
  end

  def thread_link(comment:, board:, content:, css: nil)
    link_to content, board_comment_thread_path(board, comment.comment_thread), class: css
  end
end
