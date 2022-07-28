class CommentThreadsController < BoardsBaseController
  before_action :redirect_unless_board
  before_action :redirect_unless_thread, only: %i[show destroy lock unlock]

  def show
    authorize! :read, current_thread

    @comments = current_thread.comments.least_recent_first.all.decorate
    @comment = current_thread.comments.build
    @board = current_board.decorate
    respond_to do |format|
      format.html
    end
  end

  def create
    authorize! :create, @board.threads.build
    
    result = Comments::PostThread.call(user: current_user, board: current_board,
                                       anon_name: current_anon_name, params: create_params)
    if result.success?
      redirect_to board_comment_thread_url(current_board, result.thread), notice: 'Thread created succesfully'
    else
      @thread = result.thread
      @comment = result.comment.decorate
      @threads = current_board.threads.feed.decorate
      @board = current_board.decorate
      flash.now[:alert] = result.message
      render 'boards/show', status: :unprocessable_entity
    end
  end

  def unlock
    authorize! :unlock, current_thread

    current_thread.unlock
    redirect_back_or_to board_url(current_board), notice: "Unlocked thread #{current_thread.id}"
  end

  def lock
    authorize! :lock, current_thread

    current_thread.lock
    redirect_back_or_to board_url(current_board), notice: "Locked thread #{current_thread.id}"
  end
  
  def destroy
    authorize! :destroy, current_thread

    if current_thread.destroy
      redirect_to board_url(current_board), notice: "Thread #{params[:id]} destroyed", status: :see_other
    else
      flash.now[:alert] = "Problem deleting #{params[:id]}"
      render 'show', status: :unprocessable_entity
    end
  end

  private

  def create_params
    @thread = @board.threads.build
    permitted_attrs = []
    permitted_attrs << :locked if can?(:lock, @thread)
    permitted_attrs << :sticky if can?(:sticky, @thread)
    params.permit(comment_thread: permitted_attrs, comment: %i[content image])
  end

  def current_ability
    @current_ability ||= ThreadAbility.new(current_user)
  end

  def current_thread
    @thread = current_board&.threads&.find(params[:id])
  end
end
