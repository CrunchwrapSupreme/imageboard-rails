class BoardRole < ApplicationRecord
  belongs_to :board
  belongs_to :user
  validates :user_id, presence: true
  validates :board_id, presence: true
  validates :role, presence: true

  OWNER = 3
  ADMIN = 2
  MODERATOR = 1
  USER = 0

  def role=(role)
    ensure_role!(role)
    write_attribute(:role, role_hash[role])
  end

  def role
    role_hash.invert[read_attribute(:role)]
  end

  def min_role?(role)
    ensure_role!(role)
    read_attribute(:role) >= role_hash[role]
  end

  private

  def role_hash
    {
      admin: ADMIN,
      moderator: MODERATOR,
      owner: OWNER,
      user: USER
    }
  end

  def ensure_role!(role)
    raise("Invalid role #{role}") unless role_hash.key?(role)
  end
end
