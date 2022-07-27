class Comments::PostComment
  include Interactor::Organizer

  organize Comments::CommentBuilder
end
