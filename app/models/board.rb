class Board < ApplicationRecord
  validates :short_name, presence: true, length: { maximum: 4 }
  validates :name, presence: true, length: { maximum: 16 }
  validates :description, length: { maximum: 128 }

  has_many :user_roles, class_name: 'BoardRole', dependent: :delete_all
  has_many :users, through: :user_roles

  default_scope { order('short_name DESC') }

  def role?(user, role)
    !!user_roles.find_by(user: user)&.role.eql?(role)
  end

  def min_role?(user, role)
    !!user_roles.find_by(user: user)&.min_role?(role)
  end

  def set_role(user, role)
    user_role = user_roles.find_or_initialize_by(user: user)
    user_role.role = role
    user_role.save
  end
end
