class CommentDecorator < ApplicationDecorator
  delegate_all

  def username
    if model.anonymous
      model.anon_name
    else
      model.user.username
    end
  end

  def first_comment?
    model.comment_thread.comments.first.eql?(model)
  end

  def abridged
    model.content.truncate(200)
  end
end
