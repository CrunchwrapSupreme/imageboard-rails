class ThreadAbility
  include CanCan::Ability

  def initialize(user)
    can :create, Comment, { comment_thread: { sticky: false, hidden: false, locked: false } }
    can :read, CommentThread, hidden: false
    can :create, CommentThread
    return unless user

    actions = %i[read sticky lock unlock destroy]
    if user.min_role?(:daemon)
      can actions, CommentThread
      can [:create, :destroy], Comment
    else
      can actions, CommentThread do |thread|
        thread.board.min_role?(user, :moderator)
      end

      can [:create, :destroy], Comment do |comment|
        comment.comment_thread.board.min_role?(user, :moderator)
      end
    end
  end
end
