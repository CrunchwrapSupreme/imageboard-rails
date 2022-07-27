class CommentThread < ApplicationRecord
  has_many :comments, -> { least_recent_first }, dependent: :delete_all
  accepts_nested_attributes_for :comments
  validates_with CommentThreadValidator

  belongs_to :board

  before_commit do
    self.hidden = false if hidden.nil?
    self.sticky = false if sticky.nil?
  end

  after_touch do
    self.last_bump = Time.current if bump_count < BUMP_LIMIT
    self.bump_count += 1
  end

  def lock
    self.locked = true
    save
  end

  def unlock
    self.locked = false
    save
  end

  BUMP_LIMIT = 100
  GALLERY_LIMIT = 50

  scope :most_recent_first, -> { order('created_at DESC') }
  scope :least_recent_first, -> { order('created_at ASC') }
  scope :feed, -> { where.not(hidden: true).order('sticky DESC NULLS LAST, last_bump DESC NULLS LAST, created_at DESC').limit(GALLERY_LIMIT) }
end
