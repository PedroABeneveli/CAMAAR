class TemplateQuestion < ApplicationRecord
  belongs_to :template
  enum question_type: {
    radio: "radio",
    checkbox: "checkbox",
    text: 'text',
  }
  validates :question_type, presence: true
end
