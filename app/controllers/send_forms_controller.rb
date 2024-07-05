class SendFormsController < ApplicationController
  def index
    @templates = Template.all
    @study_classes = StudyClass.all
    render layout: "home"
  end

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

  def param_value_to_study_class(key)
    StudyClass.find(key[12..].to_i)
  end

  def is_study_class_selected(key, value)
    key.starts_with?("study_class_") && value == "1"
  end
end