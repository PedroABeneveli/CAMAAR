class StudyClass < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :docente, :class_name => :User, :foreign_key => "docente_id", optional: true

  def self.find_with_json(data)
    StudyClass.find_by(code: data["code"], classCode: data["class"]["classCode"], semester: data["class"]["semester"])
  end

  def self.update_with_hash_data(json)
    if StudyClass.find_with_json(json) == nil
      StudyClass.create(code: json["code"], name: json["name"], classCode: json["class"]["classCode"], semester: json["class"]["semester"], time: json["class"]["time"])
      return true
    end

    false
  end

  def send_form_to_users(template)
    self.users.each do |user|
      FormRequest.send(template, user, self)
    end

    if self.docente.present?
      FormRequest.send(template, self.docente, self)
    end
  end
end