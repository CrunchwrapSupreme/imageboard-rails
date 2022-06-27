class CommentThreadsController < ApplicationController
  before_action :redirect_unless_board
  before_action :redirect_unless_thread, only: [:show, :destroy]
  before_action :redirect_unless_daemon_or_board_admin, only: [:destroy]

  def show
    @comments = @thread.comments.least_recent_first.all.decorate
    @comment = @thread.comments.build
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
                                 board: current_board,
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
    if @thread.destroy
      redirect_to board_url(current_board), notice: "Thread #{params[:id]} destroyed", status: :see_other
    else
      render 'show', status: :unprocessable_entity, alert: "Problem deleting #{params[:id]}"
    end
  end

  private

  def comment_thread_params
    if has_roles?(user: :daemon, board: :admin)
      params.permit(comment_thread: [:sticky], comment: [:content, :image])
    else
      params.permit(comment: [:content, :image])
    end
  end

  def redirect_unless_daemon_or_board_admin
    unauthorized! unless has_roles?(user: :daemon, board: :admin)
  end

  def redirect_unless_board
    return if current_board

    flash[:danger] = CGI.escapeHTML("Unknown board /#{params[:board_short_name]}/")
    redirect_to boards_url
  end

  def redirect_unless_thread
    @thread = current_board.threads.find_by(id: params[:id])&.decorate
    return if @thread

    flash[:danger] = CGI.escapeHTML("Unknown thread #{params[:id]}")
    redirect_to board_url(current_board)
  end
end
