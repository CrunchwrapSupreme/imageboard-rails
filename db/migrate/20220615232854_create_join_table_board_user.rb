class CreateJoinTableBoardUser < ActiveRecord::Migration[7.0]
  def change
    create_table :board_roles, id: false do |t|
      t.integer :role
      t.references :user, foreign_key: { on_delete: :cascade }
      t.references :board, foreign_key: { on_delete: :cascade }

      t.index %i[user_id board_id], unique: true
      t.timestamps
    end
  end
end
