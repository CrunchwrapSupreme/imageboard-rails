class CommentDecorator < ApplicationDecorator
  delegate_all

  def username
    if model.anonymous
      "Anon #{model.anon_name}"
    else
      "u/#{model.user.username}"
    end
  end

  def abridged
    model.content.truncate(200)
  end
end
