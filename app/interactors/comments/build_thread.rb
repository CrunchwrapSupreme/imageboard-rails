class Comments::BuildThread
  include Interactor

  delegate :board, :params, to: :context

  def call
    context.content = params.dig(:comment, :content)
    context.image = params.dig(:comment, :image)
    context.thread = board.threads.build(sticky: params.dig(:comment_thread, :sticky))
  end
end
