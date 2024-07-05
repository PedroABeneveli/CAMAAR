class GerenciamentoController < ApplicationController
  before_action :authenticate_user!
  before_action :enforce_admin!
  def index
    render layout: "home"
  end

  def import
    hash_class = JSON.parse(File.read("classes.json"))
    hash_members = JSON.parse(File.read("class_members.json"))

    if !(check_class_json hash_class) or !(check_class_members_json hash_members)
      flash[:alert] = "Dados inválidos"
    else
      new_data = false
      new_users = false

      hash_class.each do |materia|
        new_data |= StudyClass.update_with_hash_data materia
      end

      hash_members.each do |materia|
        # nao da pra usar o find with json pq a estrutura desse json eh diferente
        turma = StudyClass.find_by code: materia["code"], classCode: materia["classCode"], semester: materia["semester"]

        materia["dicente"].each do |aluno|
          pessoa = User.find_by matricula: aluno["matricula"]

          if pessoa == nil
            pessoa = User.add_student(aluno)
            new_data = true
            new_users = true
          end

          pessoa.study_classes << turma
          turma.users << pessoa
        end

        professor = materia["docente"]
        pessoa = User.find_by email: professor["email"]
        if pessoa == nil
          pessoa = User.add_teacher professor
          new_data = true
          new_users = true
        end
        turma.docente_id = pessoa.id
        pessoa.study_classes << turma
      end

      message = new_data_msg(new_data) + "\n" + new_user_msg(new_users)
      flash[:notice] = message
    end

    redirect_back_or_to "/gerenciamento"
  end

  def new_user_msg(new_user)
    if new_user
      "Usuários cadastrados com sucesso."
    else
      "Sem novos usuários."
    end
  end

  def new_data_msg(new_data)
    if new_data
      "Data imported successfully"
    else
      "Não há novos dados para importar"
    end
  end

  def check_class_members_json(json)
    keys_class_members = ["code", "classCode", "semester", "dicente", "docente"].sort
    keys_dicente = ["nome", "curso", "matricula", "usuario", "formacao", "ocupacao", "email"].sort
    keys_docente = ["nome", "departamento", "formacao", "usuario", "email", "ocupacao"].sort

    if json.respond_to? :keys
      false
    else
      json.each do |obj|
        if not obj.respond_to? :keys or obj.keys.sort != keys_class_members
          return false
        else
          # dicente eh uma lista de objs
          if obj["dicente"].respond_to? :keys
            return false
          else
            obj["dicente"].each do |aluno|
              if not aluno.respond_to? :keys or aluno.keys.sort != keys_dicente
                return false
              end
            end
          end

          if not obj["docente"].respond_to? :keys or obj["docente"].keys.sort != keys_docente
            return false
          end
        end
      end

      true
    end
  end

  def check_class_json(json)
    keys_classes = ["code", "class", "name"].sort
    keys_class = ["classCode", "semester", "time"].sort

    # sao JSONs de lista, nao eh um objeto direto
    if json.respond_to? :keys
      false
    else
      json.each do |obj|
        if not obj.respond_to? :keys or obj.keys.sort != keys_classes
          return false
        else
          if not obj["class"].respond_to? :keys or obj["class"].keys.sort != keys_class
            return false
          end
        end
      end

      true
    end
  end

  protected

  def enforce_admin!
    unless current_user.admin?
      flash[:alert] = "Usuário não tem permissão para acessar!"
      redirect_to root_path
    end
  end

end