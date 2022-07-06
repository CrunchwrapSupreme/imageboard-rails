class CommentThreadsController < BoardsBaseController
  before_action :redirect_unless_board
  before_action :redirect_unless_thread, only: %i[show destroy]
  before_action :redirect_unless_daemon_or_board_admin, only: [:destroy]

  def show
    @comments = current_thread.comments.least_recent_first.all.decorate
    @comment = current_thread.comments.build
    respond_to do |format|
      format.html
    end
  end

  def create
    c_params = comment_thread_params
    thread = current_board.threads.build(sticky: !!c_params.dig(:comment_thread, :sticky))
    result = CommentBuilder.call(user: current_user,
                                 thread: thread,
                                 anon_name: current_anon_name,
                                 content: c_params.dig(:comment, :content),
                                 image: c_params.dig(:comment, :image))

    if result.success?
      redirect_to board_comment_thread_url(current_board, result.thread), notice: 'Thread created succesfully'
    else
      @new_thread = thread.decorate
      @new_comment = result.comment.decorate
      @threads = current_board.threads.feed.decorate
      @board = current_board.decorate
      render 'boards/show', status: :unprocessable_entity, alert: 'Thread failed to create'
    end
  end

  def destroy
    if current_thread.destroy
      redirect_to board_url(current_board), notice: "Thread #{params[:id]} destroyed", status: :see_other
    else
      render 'show', status: :unprocessable_entity, alert: "Problem deleting #{params[:id]}"
    end
  end

  private

  def comment_thread_params
    if roles?(user: :daemon, board: :admin)
      params.permit(comment_thread: [:sticky], comment: %i[content image])
    else
      params.permit(comment: %i[content image])
    end
  end

  def current_thread
    @thread = current_board&.threads&.find(params[:id])&.decorate
  end
end
