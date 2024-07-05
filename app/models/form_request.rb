# Modelo que representa uma requisição de formulário associada a uma classe de estudo, usuário e modelo de formulário.
class FormRequest < ApplicationRecord
  # Associações
  #   - Pertence a uma classe de estudo, vinculando esta requisição de formulário a uma classe específica.
  #   - Pertence a um usuário, indicando o usuário que submeteu a requisição de formulário.
  #   - Pertence a um modelo de formulário, especificando o modelo usado para esta requisição de formulário.
  belongs_to :study_class
  belongs_to :user
  belongs_to :template
end
