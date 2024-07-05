class TemplatesController < ApplicationController

  # Método para listar todos os templates
  #
  # Não recebe argumentos.
  # Não retorna valor.
  # Não possui efeitos colaterais além de renderizar a página com layout "home".
  def index
    @templates = Template.all_visible
    render layout: "home"
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
    if template_params[:name] == ""
      redirect_to new_template_path, alert: "Nome do template em branco!"
      return
    end

    @template = Template.new(template_params)

    if @template.save
      redirect_to edit_template_path(@template.id), notice: 'Template iniciado com sucesso!'
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
    @template = Template.find(params[:id])
    render layout: "home"
  end

  # Método para atualizar um template existente
  #
  # Não retorna valor explícito.
  # Pode ter efeitos colaterais: atualiza um registro de Template no banco de dados ou redireciona para a página de listagem com status de erro.
  def update
    if template_params[:name] == ""
      redirect_to edit_template_path(params[:id]), alert: "Nome do template em branco!"
      return
    end

    @template = Template.find(params[:id])
    if @template.update(template_params)
      redirect_to edit_template_path(@template.id), notice: 'Template atualizado com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    id = params[:id].to_i
    template = Template.find(id)
    template.update({ hidden: true })

    redirect_to templates_path, notice: 'Template deletado com sucesso!'
  end

  private

  # Define os parâmetros permitidos para a criação e atualização de templates
  def template_params
    params.require(:template).permit(:name)
  end
end
