class Comments::BuildThread
  include Interactor

  delegate :board, :params, to: :context

  def call
    context.thread = board.threads.build(params.dig(:comment_thread))
  end
end
