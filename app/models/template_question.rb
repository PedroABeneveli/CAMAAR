# Modelo que representa uma pergunta de modelo de formulário, associada a um modelo de formulário.
class TemplateQuestion < ApplicationRecord
  # Associações
  #   - Pertence a um modelo de formulário, especificando o modelo ao qual esta pergunta pertence.
  belongs_to :template

  # Validações
  #   - Valida o tipo de pergunta, garantindo que seja um dos tipos suportados: radio, checkbox ou text.
  validates :question_type, inclusion: { in: %w(radio checkbox text) }
end
