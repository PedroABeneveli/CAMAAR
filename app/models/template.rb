class Template < ApplicationRecord
  has_many :template_questions, dependent: :destroy
  accepts_nested_attributes_for :template_questions, allow_destroy: true
end
