require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe 'find_pending_forms method' do
    it "should have a find_pending_forms function" do
      expect(user).to respond_to(:find_pending_forms)
    end

    it "should return forms" do
      frs = FactoryBot.build_list(:form_request, 5)
      frs.each do |fr|
        fr.user = user
        fr.save!
      end

      expect(user.find_pending_forms).to contain_exactly(*frs)
    end

    it "should return the right forms" do
      fr1 = FactoryBot.build(:form_request)
      fr1.user = user
      fr1.save!

      # Answered
      fr2 = FactoryBot.build(:form_request)
      fr2.answered = true
      fr2.save!

      # Different user
      FactoryBot.create(:form_request)

      expect(user.find_pending_forms).to contain_exactly(fr1)
    end
  end

  describe 'create new users based on JSON data' do
    it 'adds the student to the database and returns them' do
      std = User.add_student(student_data)

      expect(User.find_by matricula: "54321").to eq std
    end

    it 'adds the teacher to the database and returns them' do
      teacher = User.add_teacher(teacher_data)

      expect(User.find_by email: "fulano@email.com").to eq teacher
    end
  end
end

def student_data
  data = <<-EOF
    {
      "nome": "Silva",
      "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
      "matricula": "54321",
      "usuario": "54321",
      "formacao": "graduando",
      "ocupacao": "dicente",
      "email": "silva@email.com"
    } 
  EOF

  JSON.parse data
end

def teacher_data
  data = <<-EOF
    { 
      "nome": "FULANO DE CICLANO", 
      "departamento": "DEPTO CIÊNCIAS DA COMPUTAÇÃO", 
      "formacao": "DOUTORADO", "usuario": "12345", 
      "email": "fulano@email.com", 
      "ocupacao": "docente" 
    } 
  EOF

  JSON.parse data
end