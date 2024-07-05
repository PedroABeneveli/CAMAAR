class TemplatesController < ApplicationController
  before_action :set_template, except: [:index, :new, :create]

  # Método para listar todos os templates
  #
  # Não recebe argumentos.
  # Não retorna valor.
  # Não possui efeitos colaterais além de renderizar a página com layout "home".
  def index 
    @templates = Template.all
    render layout: "home"
  end

  # Método placeholder para mostrar um template específico
  #
  # Não recebe argumentos.
  # Não retorna valor.
  # Não possui efeitos colaterais.
  def show
  end

  # Método para criar um novo template
  #
  # Não retorna valor explícito.
  # Pode ter efeitos colaterais: cria um novo registro de Template no banco de dados ou redireciona para a página de criação com status de erro.
  def new
    @template = Template.new
    @template.template_questions.build
    render layout: "home"
  end

  # Método para salvar um novo template
  #
  # Não retorna valor explícito.
  # Pode ter efeitos colaterais: cria um novo registro de Template no banco de dados ou redireciona para a página de listagem com status de erro.
  def create 
    process_alternatives
    @template = Template.new(template_params)
    if @template.save
      redirect_to templates_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Método para editar um template existente
  #
  # Não recebe argumentos.
  # Não retorna valor.
  # Não possui efeitos colaterais além de renderizar a página com layout "home".
  def edit
    render layout: "home"
  end

  # Método para atualizar um template existente
  #
  # Não retorna valor explícito.
  # Pode ter efeitos colaterais: atualiza um registro de Template no banco de dados ou redireciona para a página de listagem com status de erro.
  def update 
    process_alternatives
    if @template.update(template_params)
      redirect_to templates_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Método para deletar um template existente
  #
  # Não retorna valor explícito.
  # Pode ter efeitos colaterais: deleta um registro de Template do banco de dados e redireciona para a página de listagem.
  def destroy 
    @template.destroy
    redirect_to templates_path, notice: 'Template was successfully deleted.'    
  end

  private

  # Define os parâmetros permitidos para a criação e atualização de templates
  def template_params
    params.require(:template).permit(
      :name, 
      template_questions_attributes: [:id, :title, :question_type, :content, :_destroy, alternatives: [:content]]
    )
  end

  # Configura o template a ser utilizado para as ações que necessitam de um template específico
  def set_template
    @template = Template.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to templates_path
  end

  # Processa as alternativas das perguntas do template para salvá-las em formato JSON, se aplicável
  #
  # Não retorna valor explícito.
  # Pode ter efeitos colaterais: modifica os parâmetros da requisição para incluir as alternativas em formato JSON.
  def process_alternatives
    return unless params[:template][:template_questions_attributes]
  
    params[:template][:template_questions_attributes].each do |key, question|
      if question[:question_type] == 'radio' || question[:question_type] == 'checkbox'
        if question[:alternatives].present?
          alternatives = []
          question[:alternatives].each do |key, alt| 
            alternatives << alt[:content]
          end
          question[:content] = alternatives.to_json
        else
          question[:content] = '[]' # Array JSON vazio se não houver alternativas
        end
      else
        params[:template][:template_questions_attributes][key][:content] = question[:content]
      end
    end
  end
  
end
