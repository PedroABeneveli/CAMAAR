class ChangeNameOfTypeFromTemplateQuestions < ActiveRecord::Migration[7.1]
  def change
    rename_column :template_questions, :type, :question_type
  end
end
