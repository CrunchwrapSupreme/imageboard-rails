class CommentThreadDecorator < ApplicationDecorator
  delegate_all

  def heading_post
    model.comments.least_recent_first.first.decorate
  end
end
