# Modelo que representa um modelo de formulário, contendo perguntas associadas.
class Template < ApplicationRecord
  # Associações
  #   - Tem muitas perguntas de modelo de formulário, permitindo várias perguntas associadas a este modelo.
  has_many :template_questions, dependent: :destroy

  # Aceita atributos aninhados para perguntas de modelo de formulário, permitindo a criação e destruição delas.
  accepts_nested_attributes_for :template_questions, allow_destroy: true, reject_if: :all_blank

  # Validações
  #   - Valida a presença do nome do modelo de formulário, garantindo que não seja vazio.
  validates :name, presence: true

  # Retorna:
  #   - Todos os templates visíveis
  def self.all_visible
    return Template.where(hidden: false)
  end
end