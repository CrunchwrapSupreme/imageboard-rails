class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :confirmable, :lockable, :timeoutable,
         :recoverable, :rememberable, :validatable, :trackable

  validates :role, presence: true
  validates :username, presence: true, length: { minimum: 1, maximum: 12 }
  validates_format_of :username, with: /\A[\w\-]+\z/, message: 'must contain only digits, numbers, underscores, and -'
  validates_uniqueness_of :username, message: 'is already taken'

  has_many :board_roles, class_name: 'BoardRole', dependent: :destroy
  has_many :boards, through: :board_roles
  has_many :comments

  USER = 0
  DAEMON = 1
  OWNER = 2

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
      owner: OWNER,
      daemon: DAEMON,
      user: USER
    }
  end

  def ensure_role!(role)
    raise("Invalid role #{role}") unless role_hash.key?(role)
  end
end
