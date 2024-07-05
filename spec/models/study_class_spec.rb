require 'rails_helper'

RSpec.describe StudyClass, type: :model do
  it 'finds a StudyClass with its json object' do
    turma = FactoryBot.create(:study_class, code: "CIC0105", name: "Engenharia de Software", classCode: "TB", semester: "2024.1", time: "24M34")
    data_json = class_json

    expect(StudyClass.find_with_json(data_json)).to eq turma
  end

  describe 'it updates its database based on hash data' do
    it 'creates a new user and returns a confirmation' do
      data_json = class_json

      expect(StudyClass.update_with_hash_data(data_json)).to be true
    end

    it 'returns that there isnt new data' do
      FactoryBot.create(:study_class, code: "CIC0105", name: "Engenharia de Software", classCode: "TB", semester: "2024.1", time: "24M34")
      data_json = class_json

      expect(StudyClass.update_with_hash_data(data_json)).to be false
    end
  end

  describe "sending form to users" do
    let(:study_class) { FactoryBot.build(:study_class, users: []) }

    it "should exist as a method" do
      expect(study_class).to respond_to(:send_form_to_users).with(1).arguments
    end

    it "should send a form request to every user" do
      tpt = double("template")

      us1 = double("u1")
      us2 = double("u2")
      us3 = double("u3")

      teacher = double("teacher")

      allow(study_class).to receive(:users).and_return([us1, us2, us3])
      allow(study_class).to receive(:docente).and_return(teacher)
      allow(teacher).to receive(:present?).and_return(false)

      expect(FormRequest).to receive(:send).with(tpt, us1, study_class)
      expect(FormRequest).to receive(:send).with(tpt, us2, study_class)
      expect(FormRequest).to receive(:send).with(tpt, us3, study_class)

      study_class.send_form_to_users(tpt)
    end

    it "should send a form request to the teacher" do
      tpt = double("template")

      us1 = double("u1")
      us2 = double("u2")
      us3 = double("u3")

      teacher = double("docente")

      allow(study_class).to receive(:users).and_return([us1, us2, us3])
      allow(study_class).to receive(:docente).and_return(teacher)
      allow(teacher).to receive(:present?).and_return(true)

      allow(FormRequest).to receive(:send).with(tpt, us1, study_class)
      allow(FormRequest).to receive(:send).with(tpt, us2, study_class)
      allow(FormRequest).to receive(:send).with(tpt, us3, study_class)

      expect(FormRequest).to receive(:send).with(tpt, teacher, study_class)

      study_class.send_form_to_users(tpt)
    end
  end
end

def class_json
  data = <<-EOF
      {
        "code": "CIC0105",
        "name": "Engenharia de Software",
        "class": {
            "classCode": "TB",
            "semester": "2024.1",
            "time": "24M34"
        }
      } 
  EOF

  JSON.parse(data)
end