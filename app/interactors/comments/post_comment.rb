class Comments::PostComment
  include Interactor::Organizer

  organize Comments::Persist
end
