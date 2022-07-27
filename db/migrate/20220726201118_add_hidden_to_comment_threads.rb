class AddHiddenToCommentThreads < ActiveRecord::Migration[7.0]
  def up
    add_column :comment_threads, :hidden, :boolean, default: false
    add_index :comment_threads, :hidden

    CommentThread.find_each do |thread|
      next unless thread.hidden.nil?

      thread.hidden = false
      thread.save
    end
  end

  def down
    remove_column :comment_threads, :hidden
  end
end
