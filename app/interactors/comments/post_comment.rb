class Comments::PostComment
  include Interactor::Organizer

  organize Comments::CommentAuth, Comments::CommentBuilder
end
