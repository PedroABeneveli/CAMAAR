# Controladora responsável pelas ações da tela de gerenciamento.
#
# Também é responsável por importar os dados do SIGAA, por meio do método #import.
class GerenciamentoController < ApplicationController
  before_action :authenticate_user!
  before_action :enforce_admin!

  # Método que renderiza a página inicial do gerenciamento
  #
  # Não recebe argumentos.
  # Não retorna valor.
  # Tem como efeito colateral a renderização da tela de gerenciamento.
  def index
    render layout: "home"
  end

  # Método para importar dados de turmas, alunos e professores extraídos do sigaa para o sistema.
  #
  # Recebe como parâmetro dois arquivos JSON no código fonte:
  # - classes.json: informações de turmas e matérias.
  # - class_members.json: informações dos alunos e do professor de turmas.
  #
  # Não retorna valor.
  #
  # Pode ter efeitos colaterais: criação de novos registros de usuários e turmas no banco de dados, envio de instruções de redefinição de senha por email para usuários que não estavam cadastrados no banco de dados, e renderização de avisos ou alertas sobre os dados importados.
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

  # Método para analisar os dados lidos nos JSONs.
  #
  # Tem como parâmetro:
  # - hash_class: hash resultante da leitura do arquivo "classes.json".
  # - hash_members: hash resultante da leitura do arquivo "class_members.json".
  #
  # Tem como retorno um par de Booleanos, new_data e new_users, que indicam se foram encontrados novos dados e usuários, respectivamente.
  # Pode ter como efeito colateral a atualização do banco de dados com os novos dados lidos nos arquivos.
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

  # Método que analisa os dados de um aluno para modificar o banco de dados.
  #
  # Tem como parâmetros:
  # - obj: hash com os dados do aluno.
  # - turma: objeto StudyClass que referencia a turma a qual o aluno participa.
  #
  # Tem como retorno um valor booleano que indica se esse aluno já estava registrado no sistema.
  # Possui o efeito colateral de possivelmente criar um novo usuário no sistema e criar uma instância da relação de estudo entre User e StudyClass.
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

  # Método que analisa os dados de um professor para modificar o banco de dados.
  #
  # Tem como parâmetros:
  # - obj: hash com os dados do professor.
  # - turma: objeto StudyClass que referencia a turma a qual o professor participa.
  #
  # Tem como retorno um valor booleano que indica se esse professor já estava registrado no sistema.
  # Possui o efeito colateral de possivelmente criar um novo usuário no sistema e criar uma instância da relação de professor entre User e StudyClass.
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

  # Método que retorna a mensagem de notificação sobre novos usuários.
  #
  # Tem como entrada o valor booleano new_user que indica se foi registrado pelo menos um novo usuário em uma importação de dados.
  # Retorna uma string com a mensagem a ser exibida na tela dependendo da ocorrência de novos alunos.
  # Não possui efeitos colaterais.
  def new_user_msg(new_user)
    if new_user
      "Usuários cadastrados com sucesso."
    else
      "Sem novos usuários."
    end
  end

  # Método que retorna a mensagem de notificação sobre novos dados.
  #
  # Tem como entrada o valor booleano new_user que indica se foram registrados novos dados em uma importação de dados.
  # Retorna uma string com a mensagem a ser exibida na tela dependendo da ocorrência de novos dados.
  # Não possui efeitos colaterais.
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
  # - json: Uma hash derivada de um objeto JSON a ser verificado
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
  # - json: Uma hash derivada de um objeto JSON a ser verificado
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

  # Verifica se a estrutura de um objeto de matéria é válida.
  #
  # Tem como parâmetro uma hash com a matéria a ser analisada.
  # Tem como saída um booleano indicando se a estrutura da matéria é válida.
  # Não possui efeito colateral.
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

  # Verifica se a estrutura de um objeto de turma é válida.
  #
  # Tem como parâmetro uma hash com a turma a ser analisada.
  # Tem como saída um booleano indicando se a estrutura da turma é válida.
  # Não possui efeito colateral.
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

  # Verifica se a estrutura do aluno está *incorreta*.
  #
  # Tem como parâmetro uma hash com os dados extraídos de um aluno.
  # Tem como saída um booleano indicando se a estrutura do professor é válida.
  # Não possui efeito colateral.
  def invalid_student?(aluno)
    keys_dicente = ["nome", "curso", "matricula", "usuario", "formacao", "ocupacao", "email"].sort

    (not aluno.respond_to? :keys) or aluno.keys.sort != keys_dicente
  end

  # Verifica se a estrutura do professor está *incorreta*.
  #
  # Tem como parâmetro uma hash com os dados extraídos de um professor.
  # Tem como saída um booleano indicando se a estrutura do professor é válida.
  # Não possui efeito colateral.
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