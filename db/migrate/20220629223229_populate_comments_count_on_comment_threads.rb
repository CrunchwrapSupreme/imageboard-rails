class PopulateCommentsCountOnCommentThreads < ActiveRecord::Migration[7.0]
  def up
    CommentThread.find_each do |t|
      CommentThread.reset_counters(t.id, :comments)
    end
  end
end
