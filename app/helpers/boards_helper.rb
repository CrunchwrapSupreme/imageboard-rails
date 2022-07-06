module BoardsHelper
  def current_board
    @board
  end

  def min_board_role?(role)
    !!current_board&.min_role?(current_user, role)
  end

  def thumbnail_for(comment:, board:)
    if comment.image
      url = comment.image(:medium)&.url
      url ||= comment.image.url
    end

    url ||= 'test-pattern.webp'
    content = image_tag(url, class: ['thumbnail'])

    content ||= "Thread #{comment.comment_thread.id}"
    thread_link(comment: comment, board: board, content: content, css: ['thumbnail'])
  end

  def thread_link(comment:, board:, content:, css: nil)
    link_to content, board_comment_thread_path(board, comment.comment_thread), class: css
  end
end
