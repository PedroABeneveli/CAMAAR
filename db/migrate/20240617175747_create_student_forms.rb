class CreateStudentForms < ActiveRecord::Migration[7.1]
  def change
    create_table :student_forms do |t|
      t.string :name
      t.string :semester
      t.string :teacher
      t.boolean :filled_in

      t.timestamps
    end
  end
end
