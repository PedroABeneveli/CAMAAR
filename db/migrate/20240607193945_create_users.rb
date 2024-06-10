class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :matricula
      t.string :senha
      t.string :tipo
      t.boolean :is_admin
      t.string :register_date

      t.timestamps
    end
  end
end
