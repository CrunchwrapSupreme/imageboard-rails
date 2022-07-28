class CommentsController < BoardsBaseController
  before_action :redirect_unless_board, only: [:create]
  before_action :redirect_unless_thread, only: [:create]
  before_action :redirect_unless_comment, only: [:destroy]

  def destroy
    authorize! :destroy, @comment
    @board = current_thread.board

    if @comment.destroy
      @thread = @comment.comment_thread
      redirect_to board_comment_thread_url(@board, @thread), notice: 'Comment deleted', status: :see_other
    else
      redirect_to board_url(@board), alert: 'Something went wrong', status: :see_other
    end
  end

  def create
    result = Comments::PostComment.call(user: current_user,
                                        thread: current_thread,
                                        anon_name: current_anon_name,
                                        params: create_params)

    if result.success?
      redirect_to board_comment_thread_path(@board, current_thread), notice: 'Comment created succesfully'
    else
      @comment = result.comment
      @threads = @board.threads.feed.decorate
      @comments = current_thread.comments.least_recent_first.all.decorate
      flash.now[:alert] = result.message
      render 'comment_threads/show', status: :unprocessable_entity
    end
  end

  protected

  def create_params
    params.permit(comment: %i[content image])
  end

  def redirect_unless_comment
    @comment = Comment.find(params[:id])
    return if @comment

    redirect_to board_comment_thread_path(@board, current_thread), alert: 'Unknown comment'
  end

  def current_ability
    @current_ability ||= ThreadAbility.new(current_user)
  end

  def current_thread
    @thread ||= @board.threads.find(params[:comment_thread_id])
  end
end
