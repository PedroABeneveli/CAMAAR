class RemoveSenhaFromUser < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :senha, :string
  end
end
