class CommentsController < BoardsBaseController
  before_action :redirect_unless_board, only: [:create]
  before_action :redirect_unless_thread, only: [:create]
  before_action :redirect_unless_comment, only: [:destroy]

  def destroy
    current_thread = @comment.comment_thread
    @board = current_thread.board

    unless (users_comment?(@comment) || roles?(user: :daemon, board: :moderator)) && !@comment.first_comment?
      redirect_to board_url(current_board), alert: 'Unauthorized', status: :see_other
      return
    end

    if @comment.destroy
      redirect_to board_comment_thread_url(current_board, current_thread), notice: 'Comment deleted', status: :see_other
    else
      redirect_to board_url(current_board), alert: 'Something went wrong', status: :see_other
    end
  end

  def create
    param = params.require(:comment).permit(:content, :image)
    result = CommentBuilder.call(user: current_user,
                                 thread: current_thread,
                                 anon_name: current_anon_name,
                                 board: current_board,
                                 content: param[:content],
                                 image: param[:image])

    if result.success?
      redirect_to board_comment_thread_path(current_board, current_thread), notice: 'Comment created succesfully'
    else
      @comment = result.comment.decorate
      @threads = current_board.threads.feed.decorate
      @comments = current_thread.comments.least_recent_first.all.decorate
      render 'comment_threads/show', status: :unprocessable_entity, alert: 'Comment failed to create'
    end
  end

  protected

  def redirect_unless_comment
    @comment = Comment.find(params[:id])&.decorate
    return if @comment

    redirect_to board_comment_thread_path(current_board, current_thread), alert: 'Unknown comment'
  end

  def current_thread
    @thread ||= current_board.threads.find(params[:comment_thread_id])&.decorate
  end
end
