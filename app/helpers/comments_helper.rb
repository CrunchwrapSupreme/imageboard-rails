module CommentsHelper
  def comment_thumbnail_for(comment)
    return unless comment.image

    url = comment.image(:medium)&.url
    url ||= comment.image&.url
    image_tag(url, class: ['comment_thumbnail'])
  end
end
