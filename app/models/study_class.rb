# Modelo que representa uma classe de estudo, associada a usuários e a um docente.
class StudyClass < ActiveRecord::Base
  # Associações
  #   - Tem e pertence a muitos usuários, indicando os usuários associados a esta classe de estudo.
  #   - Pertence a um docente, representado pelo modelo User através do atributo docente_id.
  has_and_belongs_to_many :users
  belongs_to :docente, class_name: 'User', foreign_key: 'docente_id', optional: true
end
