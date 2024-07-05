class SendFormsController < ApplicationController
  def index
    @templates = Template.all
    @study_classes = StudyClass.all
    render layout: "home"
  end

  def create
    template = Template.find(params[:template].to_i)

    params.each do |key, value|
      if is_study_class_selected(key, value)
        study_class = param_value_to_study_class(key)
        study_class.send_form_to_users(template)

        # study_class.users.each do |user|
        #   FormRequest.send(user, study_class)
        #   if FormRequest.find_by(user_id: u.id, study_class_id: sc.id).nil?
        #     FormRequest.create(template: template, study_class: sc, user: u)
        #   end
        # end

        # if sc.docente.present? && FormRequest.find_by(user_id: sc.docente.id, study_class_id: sc.id).nil?
        #   FormRequest.create(template: template, study_class: sc, user: sc.docente)
        # end
      end
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