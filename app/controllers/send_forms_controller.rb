class SendFormsController < ApplicationController
  # Método para renderizar a página de envio de formulários
  #
  # Não recebe argumentos.
  # Não retorna valor.
  # Não possui efeitos colaterais além de renderizar a página com layout "home".
  def index
    @templates = Template.all
    @study_classes = StudyClass.all
    render layout: "home"
  end

  # Método para criar requisições de formulários baseado nos parâmetros recebidos
  #
  # Argumentos:
  # - params: Um hash contendo os parâmetros da requisição HTTP.
  #
  # Não retorna valor explícito.
  # Pode ter efeitos colaterais: criação de novos registros de FormRequest no banco de dados.
  def create
    puts params  # Mostra os parâmetros recebidos no console para depuração

    template = Template.find(params[:templates].to_i)  # Encontra o template selecionado pelos parâmetros

    params.each do |k, v|
      if k.starts_with?("study_class_") && v == "1"  # Verifica se o parâmetro indica uma classe selecionada
        sc_id = k[12..].to_i  # Extrai o ID da classe de estudo a partir do nome do parâmetro
        puts sc_id  # Mostra o ID da classe no console para depuração

        sc = StudyClass.find(sc_id)  # Encontra a classe de estudo pelo ID
        puts sc  # Mostra a classe de estudo no console para depuração

        sc.users.each do |u|
          if FormRequest.find_by(user_id: u.id, study_class_id: sc.id).nil?
            FormRequest.create(template: template, study_class: sc, user: u)
          end
        end

        if sc.docente.present? && FormRequest.find_by(user_id: sc.docente.id, study_class_id: sc.id).nil?
          FormRequest.create(template: template, study_class: sc, user: sc.docente)
        end
      end
    end
  end
end
