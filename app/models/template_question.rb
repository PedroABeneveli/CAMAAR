# Modelo que representa uma pergunta de modelo de formulário, associada a um modelo de formulário.
class TemplateQuestion < ApplicationRecord
  # Associações
  #   - Pertence a um modelo de formulário, especificando o modelo ao qual esta pergunta pertence.
  belongs_to :template
  enum question_type: {
    radio: "radio",
    checkbox: "checkbox",
    text: 'text',
  }
  validates :question_type, presence: true
end
