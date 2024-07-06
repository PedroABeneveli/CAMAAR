# Controlador responsável pelo tratamento das requisições referentes 
# às questões dos templates nas respectivas views
class TemplateQuestionController < ApplicationController

  # Método para salvar uma nova questão
  #
  # Argumentos:
  # - params: Um hash contendo os parâmetros da requisição HTTP.
  # Não retorna valor.
  # Pode ter como efeitos colaterais: 
  # - adição de uma nova questão no atributo template_questions 
  #   do template no banco de dados.
  # - redirecionamento para a página de edição de template.
  def create
    template_id = params[:template_id].to_i

    @template = Template.find(template_id)
    @template.template_questions << TemplateQuestion.create(question_type: "text", title: "", content: "")
    @template.save!

    redirect_to edit_template_path(template_id)
  end

  # Método para atualizar uma questão existente
  #
  # Argumentos:
  # - params: Um hash contendo os parâmetros da requisição HTTP.
  # Não retorna valor.
  # Pode ter como efeitos colaterais: 
  # - renderização de mensagem de alerta para tipo inválido de questão
  # - atualização de uma questão existente no atributo template_questions 
  #   do template no banco de dados.
  # - redirecionamento para a página de edição de template.
  def update
    id = params[:id].to_i
    @template_question = TemplateQuestion.find(id)

    template_question_params = params[:template_question]
    question_type = template_question_params[:question_type]
    title = template_question_params[:title]

    if TemplateQuestion.question_types.values.include?(question_type)
      flash[:notice] = "Template atualizado com sucesso!"

      if question_type == "text"
        @template_question.update(question_type: "text", title: title, content: "")
      elsif question_type == "radio" or question_type == "checkbox"
        alternatives = []
        1.upto(10) do |i|
          if template_question_params.key?("alternative_#{i}")
            alternatives << template_question_params["alternative_#{i}"]
          else
            break
          end
        end

        @template_question.update(question_type: question_type, title: title, content: alternatives.to_json)
      else
        flash[:alert] = "Questão de tipo #{question_type} não existe!"
      end
    end

    redirect_to edit_template_path(id)
  end

  # Método para adicionar uma nova alternativa a uma questão
  #
  # Argumentos:
  # - params: Um hash contendo os parâmetros da requisição HTTP.
  # Não retorna valor.
  # Tem como efeitos colaterais: 
  # - atualização do atributo content da template_question no banco de dados.
  # - redirecionamento para a página de edição de template.
  def add_alternative
    id = params[:template_question_id].to_i
    @template_question = TemplateQuestion.find(id)

    alternatives = JSON.parse @template_question.content
    alternatives << ""

    @template_question.update({ content: alternatives.to_json })

    redirect_to edit_template_path(id)
  end
end
