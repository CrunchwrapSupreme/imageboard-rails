class Board < ApplicationRecord
  include RoleAuthable

  validates :short_name, presence: true, length: { minimum: 1, maximum: 4 }
  validates :name, presence: true, length: { minimum: 1, maximum: 16 }
  validates :description, length: { maximum: 128 }

  has_many :threads, class_name: 'CommentThread', dependent: :destroy
  has_many :board_roles, class_name: 'BoardRole', dependent: :destroy
  has_many :users, through: :board_roles

  default_scope { order('short_name DESC') }

  def to_param
    short_name
  end
end
