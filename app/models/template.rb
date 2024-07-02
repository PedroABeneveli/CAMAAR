class Template < ApplicationRecord
  has_many :template_questions

  validates :name, presence: true
end
