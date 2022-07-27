class Comments::CommentBuilder
  include Interactor
  delegate :cannot?, :can?, to: :ability
  delegate :user, to: :context

  def call
    context.comment = context.thread.comments.build(build_comment_attribs)
    authorize_comment(context.comment)

    CommentThread.transaction do
      context.thread.touch if context.thread.persisted?
      context.thread.save!
      context.comment.image_derivatives! if context.comment.image
      context.comment.save!
    end
  rescue ActiveRecord::RecordInvalid
    context.fail!(message: 'Failed to create comment on thread')
  end

  def build_comment_attribs
    if context.user
      {
        user: user,
        anonymous: false,
        content: context.content,
        image: context.image
      }
    else
      {
        anonymous: true,
        content: context.content,
        anon_name: context.anon_name,
        image: context.image
      }
    end
  end

  def authorize_comment(comment)
    return if can?(:create, comment)

    context.fail!(message: 'Not authorized to create comment on thread')
  end

  private

  def ability
    @ability ||= ::ThreadAbility.new(user)
  end
end
