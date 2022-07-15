class Comments::PostThread
  include Interactor::Organizer

  organize ::Comments::BuildThread, Comments::CommentAuth, Comments::CommentBuilder
end
