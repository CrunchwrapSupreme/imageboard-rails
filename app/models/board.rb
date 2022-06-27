class Board < ApplicationRecord
  include RoleAuthable

  validates :short_name, presence: true, length: { maximum: 4 }
  validates :name, presence: true, length: { maximum: 16 }
  validates :description, length: { maximum: 128 }

  has_many :threads, class_name: 'CommentThread', dependent: :destroy

  default_scope { order('short_name DESC') }

  def to_param
    short_name
  end
end
