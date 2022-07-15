module CommentThreadsHelper
  def new_comment_form(board:, thread:, comment:)
    render partial: 'comment_threads/new_comment_form', locals: { board: board, thread: thread, comment: comment }
  end

  def lock_or_unlock(thread:, authorized: false)
    suffix = authorized ? '' : 'ed'
    if thread.locked?
      path = unlock_board_comment_thread_path(thread.board, thread)
      icon = fa_icon('unlock', text: "Unlock#{suffix}")
    else
      path = lock_board_comment_thread_path(thread.board, thread)
      icon = fa_icon('lock', text: "Lock#{suffix}")
    end
    authorized ? link_to(icon, path, data: { "turbo-method": :put }) : icon
  end
end
