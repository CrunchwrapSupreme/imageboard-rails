class CreateCommentThreads < ActiveRecord::Migration[7.0]
  def change
    create_table :comment_threads do |t|
      t.boolean :sticky, default: false

      t.timestamps
    end
  end
end
