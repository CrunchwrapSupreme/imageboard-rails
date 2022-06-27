module CommentsHelper
  def comment_thumbnail_for(comment)
    image_tag(comment.image(:medium).url, class: ['comment_thumbnail']) if comment.image
  end
end
