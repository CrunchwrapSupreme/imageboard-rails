class AddCommentsCountToCommentThreads < ActiveRecord::Migration[7.0]
  def change
    add_column :comment_threads, :comments_count, :integer
  end
end
