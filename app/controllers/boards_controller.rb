class BoardsController < ApplicationController
  before_action :redirect_unless_board,         only: [:edit, :show, :update, :destroy]
  before_action :authenticate_user!,            only: [:edit, :destroy, :create, :update, :new]
  before_action :require_daemon_or_board_mod,   only: [:edit, :update]
  before_action :require_daemon_or_board_owner, only: [:destroy]
  before_action :require_daemon,                only: [:create, :new]

  def new
    @board = Board.new.decorate
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def index
    @boards = Board.all.decorate

    respond_to do |format|
      format.html
      format.json { render json: @boards.to_json }
    end
  end

  def show
    @new_thread = @board.threads.build
    @new_comment = @new_thread.comments.build
    @threads = @board.threads.feed.decorate
    respond_to do |format|
      format.html
      format.json { render json: @board.to_json }
    end
  end

  def create
    @board = Board.new(board_params).decorate
    if @board.save
      redirect_to board_url(@board), notice: 'Successfully created board'
    else
      render 'new', status: :unprocessable_entity, alert: 'Invalid board settings'
    end
  end

  def update
    if @board.update(update_params)
      redirect_to board_url(@board), notice: 'Successfully updated board'
    else
      render 'edit', status: :unprocessable_entity, alert: 'Invalid board settings'
    end
  end

  def destroy
    @board.destroy
    redirect_to boards_url, notice: 'Board deleted', status: :see_other
  end

  private

  def board_params
    params.require(:board).permit(:short_name, :name, :description)
  end

  def update_params
    params.require(:board).permit(:name, :description)
  end

  def redirect_unless_board
    @board = Board.find_by(short_name: params[:short_name].downcase)&.decorate
    return if @board

    flash[:danger] = CGI.escapeHTML("Unknown board /#{params[:short_name]}/")
    redirect_to boards_url
  end

  def require_daemon_or_board_mod
    return if current_user&.min_role?(:daemon) || @board.min_role?(current_user, :moderator)

    unauthorized!
  end

  def require_daemon_or_board_owner
    return if current_user&.min_role?(:daemon) || @board.min_role?(current_user, :owner)

    unauthorized!
  end
end
