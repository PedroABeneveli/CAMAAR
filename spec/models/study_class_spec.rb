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