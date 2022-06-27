class CommentsController < ApplicationController
  before_action :redirect_unless_board, only: [:create]
  before_action :redirect_unless_thread, only: [:create]
  before_action :redirect_unless_comment, only: [:destroy]

  def destroy
    @thread = @comment.comment_thread
    @board = @thread.board

    unless (users_comment?(@comment) || has_roles?(user: :daemon, board: :moderator)) && !@comment.first_comment?
      redirect_to board_url(@board), alert: 'Unauthorized', status: :see_other
      return
    end

    if @comment.destroy
      redirect_to board_comment_thread_url(@board, @thread), notice: 'Comment deleted', status: :see_other
    else
      redirect_to board_url(@board), alert: 'Something went wrong', status: :see_other
    end
  end

  def create
    param = params.require(:comment).permit(:content)
    result = CommentBuilder.call(user: current_user,
                                 thread: @thread,
                                 anon_name: current_anon_name,
                                 board: @board,
                                 content: param[:content])

    if result.success?
      redirect_to board_comment_thread_path(@board, @thread), notice: 'Comment created succesfully'
    else
      @comment = result.comment.decorate
      @threads = @board.threads.feed.decorate
      render 'comment_threads/show', status: :unprocessable_entity, alert: 'Comment failed to create'
    end
  end

  protected

  def redirect_unless_comment
    @comment = Comment.find(params[:id])&.decorate
    return if @comment

    redirect_to board_comment_thread_path(@board, @thread), alert: 'Unknown comment'
  end

  def redirect_unless_board
    @board = Board.find_by(short_name: params[:board_short_name].downcase)&.decorate
    return if @board

    redirect_to boards_url, alert: "Unknown board /#{params[:board_short_name]}/"
  end

  def redirect_unless_thread
    @thread = @board.threads.find(params[:comment_thread_id])&.decorate
    return if @thread

    redirect_to board_url(@board), alert: "Unknown thread #{params[:comment_thread_id]}"
  end
end
