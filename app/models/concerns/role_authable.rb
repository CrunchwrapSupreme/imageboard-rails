module RoleAuthable
  extend ActiveSupport::Concern
  included do
    has_many :user_roles, class_name: 'BoardRole', dependent: :destroy
    has_many :users, through: :user_roles
  end

  def role?(user, role)
    return false unless user

    !!user_roles.find_by(user: user)&.role.eql?(role)
  end

  def min_role?(user, role)
    return false unless user

    !!user_roles.find_by(user: user)&.min_role?(role)
  end

  def set_role(user, role)
    raise('No user to set on') unless user

    user_role = user_roles.find_or_initialize_by(user: user)
    user_role.role = role
    user_role.save
  end
end
