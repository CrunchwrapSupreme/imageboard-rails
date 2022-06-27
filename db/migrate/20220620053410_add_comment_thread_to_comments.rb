class AddCommentThreadToComments < ActiveRecord::Migration[7.0]
  def change
    add_reference :comments, :comment_thread, foreign_key: true
  end
end
