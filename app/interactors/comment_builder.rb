class CommentBuilder
  include Interactor

  def call
    CommentThread.transaction do
      context.thread.touch if context.thread.persisted?
      context.thread.save!
      context.comment = context.thread.comments.build(build_comment_attribs)
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
        content: context.content
      }
    else
      {
        anonymous: true,
        content: context.content,
        anon_name: context.anon_name
      }
    end
  end
end
