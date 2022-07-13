class ThreadAbility
  include CanCan::Ability

  def initialize(user)
    if user.min_role?(:daemon)
      can :create_sticky, Board
      can :lock_thread, Board
      can :unlock_thread, Board
      can :destroy_thread, Board
    else
      query = { board_roles: { user_id: user.id, role: :moderator } }
      can :create_sticky, Board, query
      can :lock_thread, Board, query
      can :unlock_thread, Board, query
      can :destroy_thread, Board, query
    end
  end
end
