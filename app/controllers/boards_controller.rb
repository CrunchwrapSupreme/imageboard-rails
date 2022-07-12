class BoardsController < BoardsBaseController
  before_action :redirect_unless_board,         only: %i[edit show update destroy]
  before_action :authenticate_user!,            only: %i[edit destroy create update new]
  before_action :require_daemon_or_board_mod,   only: %i[edit update]
  before_action :require_daemon_or_board_owner, only: [:destroy]
  before_action :require_daemon,                only: %i[create new]

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
    @thread = current_board.threads.build
    @comment = @thread.comments.build
    @threads = current_board.threads.feed.decorate
    respond_to do |format|
      format.html
      format.json { render json: current_board.to_json }
    end
  end

  def create
    @board = Board.new(board_params).decorate
    if current_board.save
      redirect_to board_url(current_board), notice: 'Successfully created board'
    else
      render 'new', status: :unprocessable_entity, alert: 'Invalid board settings'
    end
  end

  def update
    if current_board.update(update_params)
      redirect_to board_url(current_board), notice: 'Successfully updated board'
    else
      render 'edit', status: :unprocessable_entity, alert: 'Invalid board settings'
    end
  end

  def destroy
    current_board.destroy
    redirect_to boards_url, notice: 'Board deleted', status: :see_other
  end

  private

  def board_params
    params.require(:board).permit(:short_name, :name, :description)
  end

  def update_params
    params.require(:board).permit(:name, :description)
  end
end
