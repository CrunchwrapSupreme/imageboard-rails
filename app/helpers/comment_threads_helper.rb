module CommentThreadsHelper
  def new_comment_form(board:, thread:, comment:)
    render partial: 'comment_threads/new_comment_form', locals: { board: board, thread: thread, comment: comment }
  end
end
