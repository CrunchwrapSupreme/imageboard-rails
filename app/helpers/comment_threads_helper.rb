module CommentThreadsHelper
  def new_comment_form(board:, thread:, comment:)
    render partial: 'comment_threads/new_comment_form', locals: { board: board, thread: thread, comment: comment }
  end

  def lock_or_unlock(thread:, authorized: false)
    return fa_icon('lock') if thread.locked? && !authorized

    if thread.locked?
      text = 'Unlock'
      path = unlock_board_comment_thread_path(thread.board, thread)
      icon = fa_icon('lock', text: text)
    else
      text = 'Lock'
      path = lock_board_comment_thread_path(thread.board, thread)
      icon = fa_icon('unlock', text: text)
    end
    link_to(icon, path, data: { "turbo-method": :put })
  end
end
