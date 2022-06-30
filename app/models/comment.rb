class Comment < ApplicationRecord
  include ImageUploader::Attachment(:image)

  validates_presence_of :image, if: :first_comment?
  validates :content, length: { minimum: 3, maximum: 1024 }, presence: true
  validates :anon_name, presence: true, length: { is: 12 }, if: -> { anonymous == true }
  validates :comment_thread_id, presence: true
  validates :user_id, presence: true, if: -> { anonymous == false }

  belongs_to :comment_thread, touch: true, counter_cache: true
  belongs_to :user, optional: true

  scope :most_recent_first, -> { order('created_at DESC') }
  scope :least_recent_first, -> { order('created_at ASC') }

  def first_comment?
    comment_thread.comments.first.eql?(self) || comment_thread.comments.empty?
  end
end
