require 'rails_helper'

RSpec.describe GerenciamentoController, type: :controller do
  let(:user) { FactoryBot.create(:user, admin: true, matricula: "987654", email: "admin@email.com") }

  before :each do
    sign_in user
  end

  it "doesn't allow non-admins to access" do
    student = FactoryBot.create(:user, matricula: "976543", email: "user@email.com")
    sign_in student

    get :index

    expect(response).to redirect_to(root_path)
  end

  it "warns that the non-admin cant't access this page" do
    student = FactoryBot.create(:user, matricula: "976543", email: "user@email.com")
    sign_in student

    get :index

    expect(flash[:alert]).to eq "Usuário não tem permissão para acessar!"
  end

  it 'renders index' do
    expect(response).to have_http_status(:ok)
    get :index
  end

  describe 'import data' do
    describe 'invalid JSON' do
      it "warns because it's missing fields (classes.json)" do
        # fazendo um mock da leitura do arquivo pra eu conseguir testar com jsons especificos
        json_classes = <<-EOF
          [ {"code": "CIC0000", "class": { "classCode": "TA", "semester": "2024.1", "time": "25M34"} } ]
        EOF
        filepath_classes = "classes.json"
        allow(File).to receive(:read).with(filepath_classes).and_return(json_classes)

        json_members, filepath_members = valid_members
        allow(File).to receive(:read).with(filepath_members).and_return(json_members)

        put :import

        # espera que tenha um aviso
        expect(flash[:alert]).to be_present
      end

      it "warns because it's missing fields in the class data (classes.json)" do
        json_classes = <<-EOF
          [ {"code": "CIC0000", "name": "TESTE", "class": { "classCode": "TA", "semester": "2024.1"} } ]
        EOF
        filepath_classes = "classes.json"
        allow(File).to receive(:read).with(filepath_classes).and_return(json_classes)

        json_members, filepath_members = valid_members
        allow(File).to receive(:read).with(filepath_members).and_return(json_members)

        put :import

        # espera que tenha um aviso
        expect(flash[:alert]).to be_present
      end

      it "warns because it's missing fields from the class (class_member.json)" do
        json_classes, filepath_classes = valid_classes
        allow(File).to receive(:read).with(filepath_classes).and_return(json_classes)

        json_members = <<-EOF
          [ { "code": "CIC0000", "classCode": "TA", "semester": "2024.1", "docente": { 
                "nome": "FULANO DE CICLANO", "departamento": "DEPTO CIÊNCIAS DA COMPUTAÇÃO", "formacao": "DOUTORADO", "usuario": "12345", "email": "fulano@email.com", "ocupacao": "docente" } 
              } ]
        EOF
        filepath_members = "class_members.json"
        allow(File).to receive(:read).with(filepath_members).and_return(json_members)

        put :import

        expect(flash[:alert]).to be_present
      end

      it "warns because it's missing fields from the student (class_members.json)" do
        json_classes, filepath_classes = valid_classes
        allow(File).to receive(:read).with(filepath_classes).and_return(json_classes)

        json_members = <<-EOF
          [ { "code": "CIC0000", "classCode": "TA", "semester": "2024.1", 
              "dicente": [{
                "nome": "Silva",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "54321",
                "usuario": "54321",
                "formacao": "graduando",
                "ocupacao": "dicente"
              }],
              "docente": { 
                "nome": "FULANO DE CICLANO", "departamento": "DEPTO CIÊNCIAS DA COMPUTAÇÃO", "formacao": "DOUTORADO", "usuario": "12345", "email": "fulano@email.com", "ocupacao": "docente" } 
              } ]
        EOF
        filepath_members = "class_members.json"
        allow(File).to receive(:read).with(filepath_members).and_return(json_members)

        put :import

        expect(flash[:alert]).to be_present
      end

      it "warns because it's missing fields from the teacher" do
        json_classes, filepath_classes = valid_classes
        allow(File).to receive(:read).with(filepath_classes).and_return(json_classes)

        json_members = <<-EOF
          [ { "code": "CIC0000", "classCode": "TA", "semester": "2024.1", 
              "dicente": [{
                "nome": "Silva",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "54321",
                "usuario": "54321",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "silva@email.com"
              }],
              "docente": { 
                "nome": "FULANO DE CICLANO", "formacao": "DOUTORADO", "usuario": "12345", "email": "fulano@email.com", "ocupacao": "docente" 
              } 
            } 
          ]
        EOF
        filepath_members = "class_members.json"
        allow(File).to receive(:read).with(filepath_members).and_return(json_members)

        put :import

        expect(flash[:alert]).to be_present
      end

      it "warns because the JSON isn't a list (classes.json)" do
        json_classes = <<-EOF
          {"code": "CIC0000", "class": { "classCode": "TA", "semester": "2024.1", "time": "25M34"} }
        EOF
        filepath_classes = "classes.json"
        allow(File).to receive(:read).with(filepath_classes).and_return(json_classes)

        json_members, filepath_members = valid_members
        allow(File).to receive(:read).with(filepath_members).and_return(json_members)

        put :import

        expect(flash[:alert]).to be_present
      end

      it "warns because the JSON isn't a list (class_member.json)" do
        json_classes, filepath_classes = valid_classes
        allow(File).to receive(:read).with(filepath_classes).and_return(json_classes)

        json_members = <<-EOF
          { "code": "CIC0000", "classCode": "TA", "semester": "2024.1", 
            "dicente": [{
              "nome": "Silva",
              "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
              "matricula": "54321",
              "usuario": "54321",
              "formacao": "graduando",
              "ocupacao": "dicente",
              "email": "silva@email.com"
            }],
            "docente": { 
              "nome": "FULANO DE CICLANO", "departamento": "DEPTO CIÊNCIAS DA COMPUTAÇÃO", "formacao": "DOUTORADO", "usuario": "12345", "email": "fulano@email.com", "ocupacao": "docente" 
            } 
          } 
        EOF
        filepath_members = "class_members.json"
        allow(File).to receive(:read).with(filepath_members).and_return(json_members)

        put :import

        expect(flash[:alert]).to be_present
      end

      it "warns because the 'discente' field in the JSON isn't a list (class_members.json)" do
        json_classes, filepath_classes = valid_classes
        allow(File).to receive(:read).with(filepath_classes).and_return(json_classes)

        json_members = <<-EOF
          [ { "code": "CIC0000", "classCode": "TA", "semester": "2024.1", 
              "dicente": {
                "nome": "Silva",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "54321",
                "usuario": "54321",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "silva@email.com"
              },
              "docente": { 
                "nome": "FULANO DE CICLANO", "departamento": "DEPTO CIÊNCIAS DA COMPUTAÇÃO", "formacao": "DOUTORADO", "usuario": "12345", "email": "fulano@email.com", "ocupacao": "docente" 
              } 
            } 
          ]
        EOF
        filepath_members = "class_members.json"
        allow(File).to receive(:read).with(filepath_members).and_return(json_members)

        put :import

        expect(flash[:alert]).to be_present
      end
    end

    it 'warns that the data was imported successfully without errors in the JSON' do
      json_classes, filepath_classes = valid_classes
      allow(File).to receive(:read).with(filepath_classes).and_return(json_classes)

      json_members, filepath_members = valid_members
      allow(File).to receive(:read).with(filepath_members).and_return(json_members)

      put :import

      expect(flash[:notice]).to be_present
    end

    it 'saves new classes into the database' do
      json_classes, filepath_classes = valid_classes
      allow(File).to receive(:read).with(filepath_classes).and_return(json_classes)

      json_members, filepath_members = valid_members
      allow(File).to receive(:read).with(filepath_members).and_return(json_members)

      put :import

      turma = StudyClass.find_by code: "CIC0000", classCode: "TA", semester: "2024.1"

      expect(turma).not_to be(nil)
    end

    it 'adds new users that are not registered in the DB' do
      json_classes, filepath_classes = valid_classes
      allow(File).to receive(:read).with(filepath_classes).and_return(json_classes)

      json_members, filepath_members = valid_members
      allow(File).to receive(:read).with(filepath_members).and_return(json_members)

      put :import

      person = User.find_by matricula: "54321"

      expect(person).not_to be(nil)
    end

    it 'links the student to the specified class' do
      json_classes, filepath_classes = valid_classes
      allow(File).to receive(:read).with(filepath_classes).and_return(json_classes)

      json_members, filepath_members = valid_members
      allow(File).to receive(:read).with(filepath_members).and_return(json_members)

      put :import

      person = User.find_by matricula: "54321"
      turma = StudyClass.find_by code: "CIC0000", classCode: "TA", semester: "2024.1"

      expect(person.study_classes.include?(turma)).to be true
    end

    it 'links the class to the student' do
      json_classes, filepath_classes = valid_classes
      allow(File).to receive(:read).with(filepath_classes).and_return(json_classes)

      json_members, filepath_members = valid_members
      allow(File).to receive(:read).with(filepath_members).and_return(json_members)

      put :import

      person = User.find_by matricula: "54321"
      turma = StudyClass.find_by code: "CIC0000", classCode: "TA", semester: "2024.1"

      expect(turma.users.include?(person)).to be true
    end

    it 'calls the devise mailer to send an email to all new users that are created' do
      json_classes, filepath_classes = valid_classes
      allow(File).to receive(:read).with(filepath_classes).and_return(json_classes)

      json_members, filepath_members = valid_members
      allow(File).to receive(:read).with(filepath_members).and_return(json_members)

      # esperar que o mailer receba o metodo para enviar
      # so que se nao colocar retorno da ruim, tem que retornar um objeto Mailer tbm
      # sao 2 novos usuarios no JSON que eu fiz
      expect(Devise.mailer).to receive(:send).and_return(double("Devise::Mailer", :deliver => true)).twice

      # nao funcionou, tava querendo saber quantas vezes foi chamada
      # expect(User).to receive(:send_reset_password_instructions).and_call_original

      put :import
    end

    it 'does not send an email when all users on the JSON already exist' do
      json_classes, filepath_classes = valid_classes
      allow(File).to receive(:read).with(filepath_classes).and_return(json_classes)

      json_members, filepath_members = valid_members
      allow(File).to receive(:read).with(filepath_members).and_return(json_members)

      FactoryBot.build(:user, nome: "Silva", matricula: "54321", usuario: "54321", email: "silva@email.com").save
      FactoryBot.build(:user, nome: "FULANO DE CICLANO", matricula: "12345", usuario: "12345", email: "fulano@email.com").save

      expect(Devise.mailer).not_to receive(:send)

      put :import
    end

    describe 'error message' do
      describe 'new users' do
        it 'says when there are new users' do
          msg = controller.new_user_msg(true)

          expect(msg).to include "Usuários cadastrados com sucesso."
        end

        it 'says when there are no new users' do
          msg = controller.new_user_msg(false)

          expect(msg).to include "Sem novos usuários."
        end
      end

      describe 'new data' do
        it 'says when there is new data' do
          msg = controller.new_data_msg(true)

          expect(msg).to include "Data imported successfully"
        end

        it "says when there isn't new data" do
          msg = controller.new_data_msg(false)

          expect(msg).to include "Não há novos dados para importar"
        end
      end
    end
  end
end

# metodos pra deixar os testes mais enxutos, nao ficar colocando o mesmo texto toda vez
def valid_classes
  data = <<-EOF
        [ {"code": "CIC0000", "name": "TESTE", "class": { "classCode": "TA", "semester": "2024.1", "time": "25M34"} } ]
  EOF
  path = "classes.json"

  [data, path]
end

def valid_members
  data = <<-EOF
    [ { "code": "CIC0000", "classCode": "TA", "semester": "2024.1", 
        "dicente": [{
          "nome": "Silva",
          "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
          "matricula": "54321",
          "usuario": "54321",
          "formacao": "graduando",
          "ocupacao": "dicente",
          "email": "silva@email.com"
        }],
        "docente": { 
          "nome": "FULANO DE CICLANO", "departamento": "DEPTO CIÊNCIAS DA COMPUTAÇÃO", "formacao": "DOUTORADO", "usuario": "12345", "email": "fulano@email.com", "ocupacao": "docente" 
        } 
      } 
    ]
  EOF
  path = "class_members.json"

  [data, path]
end