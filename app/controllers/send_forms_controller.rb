# Controlador responsável pelo tratamento das requisições referentes 
# à view de envio de formulários para os alunos
class SendFormsController < ApplicationController
  # Método para renderizar a página de envio de formulários
  #
  # Não recebe argumentos.
  # Não retorna valor.
  # Tem como efeito colateral a renderização da página de envio de formulários
  def index
    @templates = Template.all
    @study_classes = StudyClass.all
    render layout: "home"
  end

  # Método para criar requisições de formulários baseado nos parâmetros recebidos
  #
  # Argumentos:
  # - params: Um hash contendo os parâmetros da requisição HTTP.
  #
  # Não retorna valor explícito.
  # Pode ter efeitos colaterais: criação de novos registros de FormRequest no banco de dados.
  def create
    template = Template.find(params[:template].to_i)

    num_selected = 0
    params.each do |key, value|
      if is_study_class_selected(key, value)
        num_selected += 1

        study_class = param_value_to_study_class(key)
        study_class.send_form_to_users(template)
      end
    end

    if num_selected == 0
      redirect_to send_forms_path, alert: "Nenhuma turma selecionada!"
    else
      redirect_to gerenciamento_path, notice: "Formulário enviado com sucesso!"
    end
  end

  private

  # Métodos para facilitar a compreensão do código com minemônicos

  def param_value_to_study_class(key)
    StudyClass.find(key[12..].to_i)
  end

  def is_study_class_selected(key, value)
    key.starts_with?("study_class_") && value == "1"
  end
end