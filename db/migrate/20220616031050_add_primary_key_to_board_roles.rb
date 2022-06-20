class AddPrimaryKeyToBoardRoles < ActiveRecord::Migration[7.0]
  def change
    add_column :board_roles, :id, :primary_key
  end
end
