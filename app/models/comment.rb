class Comment < ApplicationRecord
  include ImageUploader::Attachment(:image)

  validates_presence_of :image, if: :first_comment?
  validates :content, length: { minimum: 3, maximum: 1024 }, presence: true
  validates :anon_name, presence: true, length: { is: 12 }, if: -> { anonymous == true }
  validates :comment_thread_id, presence: true
  validates :user_id, presence: true, if: -> { anonymous == false }

  after_destroy_commit { broadcast_remove_to([comment_thread, :comments]) }

  before_validation do
    self.content = content.strip
    if anonymous?
      self.user_id = nil
    else
      self.anon_name = nil
    end
  end

  belongs_to :comment_thread, touch: true, counter_cache: true
  belongs_to :user, optional: true

  scope :most_recent_first, -> { order('created_at DESC') }
  scope :least_recent_first, -> { order('created_at ASC') }

  def first_comment?
    comment_thread.comments.first.eql?(self) || comment_thread.comments.empty?
  end

  def username
    if anonymous?
      "Anon #{anon_name}"
    else
      "u/#{user.username}"
    end
  end
end
