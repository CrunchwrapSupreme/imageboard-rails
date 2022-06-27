class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :content, limit: 1024, null: false
      t.boolean :anonymous, default: true, null: false
      t.string :anon_name, null: true
      t.references :user, foreign_key: { on_delete: :cascade }, null: true

      t.timestamps
    end
  end
end
