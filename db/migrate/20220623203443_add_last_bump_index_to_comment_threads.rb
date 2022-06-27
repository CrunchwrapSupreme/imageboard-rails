class AddLastBumpIndexToCommentThreads < ActiveRecord::Migration[7.0]
  def change
    add_index :comment_threads, :last_bump
  end
end
