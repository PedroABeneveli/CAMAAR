class GerenciamentoController < ApplicationController
  before_action :authenticate_user!
  before_action :enforce_admin!

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

    if !(valid_class_json? hash_class) or !(valid_class_members_json? hash_members)
      flash[:alert] = "Dados inválidos"
    else
      new_data, new_users = add_import_data hash_class, hash_members

      message = new_data_msg(new_data) + "\n" + new_user_msg(new_users)
      flash[:notice] = message
    end

    redirect_back_or_to "/gerenciamento"
  end

  def add_import_data(hash_class, hash_members)
    new_data = false
    new_users = false

    hash_class.each do |materia|
      new_data |= StudyClass.update_with_hash_data materia
    end

      hash_members.each do |materia|
        turma = StudyClass.find_by code: materia["code"], classCode: materia["classCode"], semester: materia["semester"]

      materia["dicente"].each do |aluno|
        new_users |= add_student(aluno, turma)
        new_data |= new_users
      end

      new_users |= add_teacher(materia["docente"], turma)
      new_data |= new_users
    end

    [new_data, new_users]
  end

  def add_student(obj, turma)
    pessoa = User.find_by matricula: obj["matricula"]

    new_info = false
    if pessoa == nil
      pessoa = User.add_student(obj)
      new_info = true
    end

    pessoa.study_classes << turma
    turma.users << pessoa

    new_info
  end

  def add_teacher(obj, turma)
    pessoa = User.find_by email: obj["email"]

    new_info = false
    if pessoa == nil
      pessoa = User.add_teacher obj
      new_info = true
    end
    turma.docente_id = pessoa.id
    pessoa.study_classes << turma

    new_info
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

  # Método para verificar a estrutura do JSON de membros de classe
  #
  # Argumentos:
  # - json: Um objeto JSON a ser verificado
  #
  # Retorna true se a estrutura do JSON estiver correta, false caso contrário.
  # Não possui efeitos colaterais.
  def valid_class_members_json?(json)
    if json.respond_to? :keys
      false
    else
      json.each do |obj|
        if not valid_class_details_format? obj
          return false
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
  def valid_class_json?(json)
    # sao JSONs de lista, nao eh um objeto direto
    if json.respond_to? :keys
      false
    else
      json.each do |obj|
        if not valid_class_general_info? obj
          return false
        end
      end

      true
    end
  end

  def valid_class_general_info?(obj)
    keys_classes = ["code", "class", "name"].sort
    keys_class = ["classCode", "semester", "time"].sort

    if not obj.respond_to? :keys or obj.keys.sort != keys_classes
      false
    else
      turma = obj["class"]
      if not turma.respond_to? :keys or turma.keys.sort != keys_class
        return false
      end

      true
    end
  end

  def valid_class_details_format?(obj)
    keys_class_members = ["code", "classCode", "semester", "dicente", "docente"].sort

    if not obj.respond_to? :keys or obj.keys.sort != keys_class_members
      false
    else
      # dicente eh uma lista de objs
      if obj["dicente"].respond_to? :keys
        return false
      else
        obj["dicente"].each do |aluno|
          if invalid_student? aluno
            return false
          end
        end
      end

      if invalid_teacher?(obj["docente"])
        return false
      end

      true
    end
  end

  def invalid_student?(aluno)
    keys_dicente = ["nome", "curso", "matricula", "usuario", "formacao", "ocupacao", "email"].sort

    (not aluno.respond_to? :keys) or aluno.keys.sort != keys_dicente
  end

  def invalid_teacher?(docente)
    keys_docente = ["nome", "departamento", "formacao", "usuario", "email", "ocupacao"].sort

    (not docente.respond_to? :keys) or docente.keys.sort != keys_docente
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