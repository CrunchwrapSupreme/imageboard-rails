class CreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :boards do |t|
      t.string :short_name,  limit: 4,  null: false
      t.string :name,        limit: 16, null: false
      t.string :description, limit: 128

      t.index :short_name, unique: true

      t.timestamps
    end
  end
end
