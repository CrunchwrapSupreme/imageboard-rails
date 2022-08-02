class Comments::Persist
  include Interactor
  delegate :comment, :thread, :user, :anon_name, to: :context
  delegate :cannot?, :can?, to: :ability

  def call
    CommentThread.transaction do
      thread.save! unless thread.persisted?
      context.comment = context.thread.comments.build(build_comment_attribs)
      authorize_comment(comment)
      comment.save!
      thread.save! if thread.changed?
    end
  rescue ActiveRecord::RecordInvalid
    context.fail!(message: 'Failed to create comment on thread')
  end

  def build_comment_attribs
    comment_attribs = if user
                        {
                          user: user,
                          anonymous: false
                        }
                      else
                        {
                          anonymous: true,
                          anon_name: anon_name
                        }
                      end
    context.params.require(:comment).merge(comment_attribs)
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
