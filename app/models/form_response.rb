# Modelo que representa uma resposta de formulário associada a uma classe de estudo e modelo de formulário.
require 'csv'

class FormResponse < ApplicationRecord
  # Associações
  #   - Pertence a uma classe de estudo, vinculando esta resposta de formulário a uma classe específica.
  #   - Pertence a um modelo de formulário, especificando o modelo usado para esta resposta de formulário.
  belongs_to :study_class
  belongs_to :template

  # Encontra todas as respostas de formulário associadas a uma determinada classe de estudo.
  # 
  # Argumentos:
  #   - study_class: A classe de estudo para a qual as respostas de formulário devem ser encontradas.
  # 
  # Retorna:
  #   - Um objeto ActiveRecord::Relation contendo todas as respostas de formulário associadas à classe de estudo especificada.
  def self.find_with_study_class(study_class)
    self.where(study_class: study_class)
  end

  # Converte uma coleção de respostas de formulário para um arquivo CSV.
  # 
  # Argumentos:
  #   - forms: Uma coleção de objetos FormResponse que serão convertidos para CSV.
  # 
  # Retorna:
  #   - Uma string contendo os dados CSV gerados a partir das respostas de formulário.
  # 
  # Efeitos colaterais:
  #   - Gera um arquivo CSV com os dados das respostas de formulário.
  def self.to_csv(forms)
    attributes = %w{form_id turma semestre pergunta resposta data}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      forms.each do |form|
        answers = JSON.parse form.response
        form.template.template_questions.each_with_index do |q, idx|
          csv << [form.id, form.study_class.classCode, form.study_class.semester, q.title, answers[idx], form.created_at]
        end
      end
    end
  end
end
