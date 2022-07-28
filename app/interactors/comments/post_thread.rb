class Comments::PostThread
  include Interactor::Organizer

  organize Comments::BuildThread, Comments::Persist
end
