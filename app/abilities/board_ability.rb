class BoardAbility
  include CanCan::Ability

  def initialize(user)
    can :read, Board
    return unless user

    if user.min_role?(:daemon)
      can [:create, :update, :destroy], Board
    else
      can :update, Board do |board|
        board.min_role?(user, :admin)
      end

      can :destroy, Board do |board|
        board.min_role?(user, :owner)
      end
    end
  end
end
