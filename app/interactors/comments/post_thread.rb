class Comments::PostThread
  include Interactor::Organizer

  organize ::Comments::BuildThread, Comments::ThreadAuth, Comments::CommentBuilder
end
