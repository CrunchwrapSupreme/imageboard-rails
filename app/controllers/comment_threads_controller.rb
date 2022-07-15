class CommentThreadsController < BoardsBaseController
  before_action :redirect_unless_board
  before_action :redirect_unless_thread, only: %i[show destroy lock unlock]
  before_action :redirect_unless_daemon_or_board_admin, only: [:destroy]

  def show
    @comments = current_thread.comments.least_recent_first.all.decorate
    @comment = current_thread.comments.build
    @board = current_board.decorate
    respond_to do |format|
      format.html
    end
  end

  def create
    result = Comments::PostThread.call(user: current_user, board: current_board,
                                       anon_name: current_anon_name, params: create_params)
    if result.success?
      redirect_to board_comment_thread_url(current_board, result.thread), notice: 'Thread created succesfully'
    else
      @thread = thread.decorate
      @comment = result.comment.decorate
      @threads = current_board.threads.feed.decorate
      @board = current_board.decorate
      render 'boards/show', status: :unprocessable_entity, alert: result.message
    end
  end

  def unlock
    if can?(:lock_thread, current_board)
      current_thread.unlock
      redirect_back_or_to board_url(current_board), notice: "Unlocked thread #{current_thread.id}"
    else
      redirect_back_or_to boards_url(current_board), alert: 'Not authorized to unlock thread', status: :see_other
    end
  end

  def lock
    if can?(:lock_thread, current_board)
      current_thread.lock
      redirect_back_or_to board_url(current_board), notice: "Locked thread #{current_thread.id}"
    else
      redirect_back_or_to board_url(current_board), alert: 'Not authorized to lock thread', status: :see_other
    end
  end

  def destroy
    unless can?(:destroy_thread, current_board)
      redirect_to board_url(current_board), status: :see_other, alert: 'Unauthorized'
    end

    if current_thread.destroy
      redirect_to board_url(current_board), notice: "Thread #{params[:id]} destroyed", status: :see_other
    else
      render 'show', status: :unprocessable_entity, alert: "Problem deleting #{params[:id]}"
    end
  end

  private

  def create_params
    if can?(:create_sticky, current_board)
      params.permit(comment_thread: [:sticky], comment: %i[content image])
    else
      params.permit(comment: %i[content image])
    end
  end

  def current_ability
    @current_ability ||= ThreadAbility.new(current_user)
  end

  def current_thread
    @thread = current_board&.threads&.find(params[:id])&.decorate
  end
end
