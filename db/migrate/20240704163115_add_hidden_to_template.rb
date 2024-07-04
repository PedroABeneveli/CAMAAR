class AddHiddenToTemplate < ActiveRecord::Migration[7.1]
  def change
    add_column :templates, :hidden, :boolean, default: false
  end
end
