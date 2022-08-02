module CommentThreadsHelper
  def new_comment_form(board:, thread:, comment:)
    render partial: 'comment_threads/new_comment_form', locals: { board: board, thread: thread, comment: comment }
  end

  def lock_or_unlock(thread:, authorized: false)
    if thread.locked?
      path = unlock_board_comment_thread_path(thread.board, thread)
      icon_or_link('lock', 'Unlock', path, authorized)
    else
      path = lock_board_comment_thread_path(thread.board, thread)
      icon_or_link('unlock', 'Lock', path, authorized)
    end
  end

  private

  def icon_or_link(icon, text, path, authorized)
    if authorized
      ficon = fa_icon(icon, text: text)
      link_to(ficon, path, data: { "turbo-method": :put })
    else
      fa_icon(icon)
    end
  end
end
