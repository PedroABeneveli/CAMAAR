# Modelo que representa uma classe de estudo, associada a usuários e a um docente.
class StudyClass < ActiveRecord::Base
  # Associações
  #   - Tem e pertence a muitos usuários, indicando os usuários associados a esta classe de estudo.
  #   - Pertence a um docente, representado pelo modelo User através do atributo docente_id.
  has_and_belongs_to_many :users
  belongs_to :docente, :class_name => :User, :foreign_key => "docente_id", optional: true

  # Retorna a primeira classe encontrada com os parâmetros do filtro
  # Argumentos: 
  #     - data: um json com os filtros para encontrar a classe
  # Retorna:
  #     - A primeira classe que possui os atributos do filtro. Se nenhuma corresponder, retorna nil
  def self.find_with_json(data)
    StudyClass.find_by(code: data["code"], classCode: data["class"]["classCode"], semester: data["class"]["semester"])
  end

  # Checa se existe um objeto com os parâmetros passados e cria se não existir
  # Argumentos:
  #   - um json com os parâmetros
  # Retorna:
  #   - true se o objeto foi criado e false se o objeto já existia
  def self.update_with_hash_data(json)
    if StudyClass.find_with_json(json) == nil
      StudyClass.create(code: json["code"], name: json["name"], classCode: json["class"]["classCode"], semester: json["class"]["semester"], time: json["class"]["time"])
      return true
    end

    false
  end

  # Manda um template de formulário para os usuários
  # Argumentos:
  #   - o template a ser enviado
  def send_form_to_users(template)
    self.users.each do |user|
      FormRequest.send_form(template, user, self)
    end

    if self.docente.present?
      FormRequest.send_form(template, self.docente, self)
    end
  end
end