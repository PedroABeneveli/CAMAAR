class GerenciamentoController < ApplicationController
  before_action :authenticate_user!  # Requer autenticação de usuário antes de qualquer ação
  before_action :enforce_admin!       # Garante que apenas administradores tenham acesso a certas ações

  # Método que renderiza a página inicial do gerenciamento
  #
  # Não recebe argumentos.
  # Não retorna valor.
  # Não possui efeitos colaterais.
  def index
    render layout: "home"
  end

  # Método para importar dados de arquivos JSON para o sistema
  #
  # Não recebe argumentos.
  # Não retorna valor.
  # Pode ter efeitos colaterais: criação de novos registros no banco de dados e envio de instruções de redefinição de senha por email.
  def import
    hash_class = JSON.parse(File.read("classes.json"))
    hash_members = JSON.parse(File.read("class_members.json"))

    if !(check_class_json hash_class) or !(check_class_members_json hash_members)
      flash[:alert] = "Dados inválidos"
    else
      new_data = false
      new_users = false

      hash_class.each do |materia|
        if StudyClass.find_by(code: materia["code"], classCode: materia["class"]["classCode"], semester: materia["class"]["semester"]) == nil
          StudyClass.create(code: materia["code"], name: materia["name"], classCode: materia["class"]["classCode"], semester: materia["class"]["semester"], time: materia["class"]["time"])
          new_data = true
        end
      end

      hash_members.each do |materia|
        turma = StudyClass.find_by code: materia["code"], classCode: materia["classCode"], semester: materia["semester"]

        materia["dicente"].each do |aluno|
          pessoa = User.find_by matricula: aluno["matricula"]

          if pessoa == nil
            pessoa = User.new nome: aluno["nome"], curso: aluno["curso"], matricula: aluno["matricula"], usuario: aluno["usuario"], formacao: aluno["formacao"], ocupacao: aluno["ocupacao"], email: aluno["email"]
            pessoa.skip_password_validation = true
            pessoa.save
            new_data = true

            pessoa.send_reset_password_instructions
            new_users = true
          end

          pessoa.study_classes << turma
          turma.users << pessoa
        end

        professor = materia["docente"]
        pessoa = User.find_by email: professor["email"]
        if pessoa == nil
          pessoa = User.new nome: professor["nome"], departamento: professor["departamento"], formacao: professor["formacao"], matricula: professor["usuario"], usuario: professor["usuario"], email: professor["email"], ocupacao: professor["ocupacao"]
          pessoa.skip_password_validation = true
          pessoa.save
          new_data = true

          pessoa.send_reset_password_instructions
          new_users = true
        end
        turma.docente_id = pessoa.id
        pessoa.study_classes << turma
      end

      message = ""
      if new_data
        message += "Data imported successfully"
      else
        message += "Não há novos dados para importar"
      end

      if new_users
        message += "\nUsuários cadastrados com sucesso."
      else
        message += "\nSem novos usuários."
      end

      flash[:notice] = message
    end

    redirect_back_or_to "/gerenciamento"
  end

  # Método para verificar a estrutura do JSON de membros de classe
  #
  # Argumentos:
  # - json: Um objeto JSON a ser verificado
  #
  # Retorna true se a estrutura do JSON estiver correta, false caso contrário.
  # Não possui efeitos colaterais.
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
          # dicente é uma lista de objetos
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

  # Método para verificar a estrutura do JSON de classes
  #
  # Argumentos:
  # - json: Um objeto JSON a ser verificado
  #
  # Retorna true se a estrutura do JSON estiver correta, false caso contrário.
  # Não possui efeitos colaterais.
  def check_class_json(json)
    keys_classes = ["code", "class", "name"].sort
    keys_class = ["classCode", "semester", "time"].sort

    # São JSONs de lista, não é um objeto direto
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

  # Método para garantir que apenas administradores tenham acesso a certas ações
  #
  # Não recebe argumentos.
  # Não retorna valor.
  # Pode ter efeito colateral: redireciona o usuário não autorizado para a página inicial.
  def enforce_admin!
    unless current_user.admin?
      flash[:alert] = "Usuário não tem permissão para acessar!"
      redirect_to root_path
    end
  end
end
