class CommentsController < BoardsBaseController
  before_action :redirect_unless_board, only: [:create]
  before_action :redirect_unless_thread, only: [:create]
  before_action :redirect_unless_comment, only: [:destroy]

  def destroy
    current_thread = @comment.comment_thread
    @board = current_thread.board

    if @comment.first_comment? || cannot?(:destroy, @comment)
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
    result = Comments::PostComment.call(user: current_user,
                                        thread: current_thread,
                                        anon_name: current_anon_name,
                                        content: param[:content],
                                        image: param[:image])

    if result.success?
      redirect_to board_comment_thread_path(current_board, current_thread), notice: 'Comment created succesfully'
    else
      @comment = result.comment
      @threads = current_board.threads.feed.decorate
      @comments = current_thread.comments.least_recent_first.all.decorate
      render 'comment_threads/show', status: :unprocessable_entity, alert: result.message
    end
  end

  protected

  def redirect_unless_comment
    @comment = Comment.find(params[:id])
    return if @comment

    redirect_to board_comment_thread_path(current_board, current_thread), alert: 'Unknown comment'
  end

  def current_ability
    @current_ability ||= ThreadAbility.new(current_user)
  end

  def current_thread
    @thread ||= current_board.threads.find(params[:comment_thread_id])
  end
end
