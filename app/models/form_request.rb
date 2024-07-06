# Modelo que representa uma requisição de formulário associada a uma classe de estudo, usuário e modelo de formulário.
class FormRequest < ApplicationRecord
  # Associações
  #   - Pertence a uma classe de estudo, vinculando esta requisição de formulário a uma classe específica.
  #   - Pertence a um usuário, indicando o usuário que submeteu a requisição de formulário.
  #   - Pertence a um modelo de formulário, especificando o modelo usado para esta requisição de formulário.
  belongs_to :study_class
  belongs_to :user
  belongs_to :template

  # Cria um novo form request, que liga um template com um usuário e uma turma, para que o aluno possa responder
  #
  # Recebe como parâmetros:
  # - template: um Template referente ao formato do formulário a ser enviado
  # - user: um User que receberá o formulário a ser respondido
  # - study_class: um StudyClass referente a qual turma deverá ser avaliada naquele formulário
  #
  # Não há retorno.
  # Esse método possui o efeito colateral de possivelmente adicionar uma instância de FormRequest caso não exista uma relação entre os Template, User e StudyClass fornecidos como parâmetro.
  def self.send_form(template, user, study_class)
    fr = FormRequest.find_by({ template_id: template.id, user_id: user.id, study_class_id: study_class.id })

    if fr.nil?
      FormRequest.create({ template: template, user: user, study_class: study_class })
    end
  end
end
