class Comments::CommentAuth
  include Interactor
  delegate :user, :thread, to: :context
  delegate :cannot?, :can?, to: :ability

  def call
    if thread.sticky && cannot?(:comment_sticky, thread.board)
      context.fail!(message: 'Not authorized to comment on sticky')
    end

    if thread.locked? && cannot?(:comment_locked, thread.board)
      context.fail!(message: 'Cannot comment on locked thread')
    end
  end

  private

  def ability
    ::ThreadAbility.new(user)
  end
end
