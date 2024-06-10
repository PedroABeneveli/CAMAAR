class RemoveFieldNameFromTableName < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :register_date, :string
  end
end
