class AddBumpCountToCommentThreads < ActiveRecord::Migration[7.0]
  def change
    add_column :comment_threads, :bump_count, :integer, default: 0, null: false
    add_column :comment_threads, :last_bump, :datetime
  end
end
