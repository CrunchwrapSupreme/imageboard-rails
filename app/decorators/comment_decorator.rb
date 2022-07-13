class CommentDecorator < ApplicationDecorator
  delegate_all

  def abridged
    model.content.truncate(200)
  end
end
