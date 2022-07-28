class BoardsController < BoardsBaseController
  before_action :redirect_unless_board, only: %i[edit show update destroy]
  load_and_authorize_resource find_by: :short_name

  def new
    @board = @board.decorate
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    if @board.update(update_params)
      redirect_to board_url(@board), notice: 'Successfully updated board'
    else
      flash.now[:alert] = 'Invalid board settings'
      render 'edit', status: :unprocessable_entity
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
    @current_ability = ThreadAbility.new(current_user)
    @thread = @board.threads.build
    @comment = @thread.comments.build
    @threads = @board.threads.feed.accessible_by(@current_ability).decorate
    @board = @board.decorate
    respond_to do |format|
      format.html
      format.json { render json: @board.to_json }
    end
  end

  def create
    if @board.save
      redirect_to board_url(@board), notice: 'Successfully created board'
    else
      @board = @board.decorate
      flash.now[:alert] = 'Invalid board settings'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    if @board.destroy
      redirect_to boards_url, notice: 'Board deleted', status: :see_other
    else
      redirect_to boards_url, alert: 'Could not delete board', status: :unprocessable_entity
    end
  end

  private

  def current_ability
    @current_ability ||= BoardAbility.new(current_user)
  end

  def create_params
    params.require(:board).permit(:short_name, :name, :description)
  end

  def update_params
    params.require(:board).permit(:name, :description)
  end
end
