class CommentBuilder
  include Interactor

  def call
    CommentThread.transaction do
      context.thread.touch if context.thread.persisted?
      context.thread.save!
      context.comment = context.thread.comments.build(build_comment_attribs)
      context.comment.image_derivatives! if context.comment.image
      context.comment.save!
    end
  rescue ActiveRecord::RecordInvalid => e
    context.fail!(error: e.message)
  end

  def build_comment_attribs
    if context.user
      {
        user: context.user,
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
end
