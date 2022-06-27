class AddBoardIdToCommentThreads < ActiveRecord::Migration[7.0]
  def change
    add_reference :comment_threads, :board, foreign_key: { on_delete: :cascade }, null: false
  end
end
