class FormRequest < ApplicationRecord
  belongs_to :study_class
  belongs_to :user
  belongs_to :template

  def self.send_form(template, user, study_class)
    fr = FormRequest.find_by({ template_id: template.id, user_id: user.id, study_class_id: study_class.id })

    if fr.nil?
      FormRequest.create({ template: template, user: user, study_class: study_class })
    end
  end
end
