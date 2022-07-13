module CommentThreadsHelper
  def new_comment_form(board:, thread:, comment:)
    render partial: 'comment_threads/new_comment_form', locals: { board: board, thread: thread, comment: comment }
  end

  def lock_or_unlock(thread:)
    if thread.locked?
      path = unlock_board_comment_thread_path(thread.board, thread)
      link_to(fa_icon('unlock', text: 'Unlock'), path, data: { "turbo-method": :put })
    else
      path = lock_board_comment_thread_path(thread.board, thread)
      link_to(fa_icon('lock', text: 'Lock'), path, data: { "turbo-method": :put })
    end
  end
end
