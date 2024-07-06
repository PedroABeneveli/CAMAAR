# Controlador responsável pelo tratamento das requisições das views dos templates
class TemplatesController < ApplicationController

  # Método para listar todos os templates
  #
  # Não recebe argumentos.
  # Não retorna valor.
  # Tem como efeito colateral a renderização da página 
  # de visualização dos templates não deletados. 
  def index
    @templates = Template.all_visible
    render layout: "home"
  end

  # Método para criar um novo template
  #
  # Não recebe argumentos
  # Não retorna valor.
  # Tem como efeito colateral a criação de um novo registro
  # de Template no banco de dados.
  def new
    @template = Template.new

    render layout: "home"
  end

  # Método para salvar um novo template
  #
  # Argumentos:
  # - template_params: Um hash contendo os parâmetros da requisição HTTP com acesso externo permitido.
  # Não retorna valor.
  # Pode ter como efeitos colaterais: 
  # - redirecionamento para a tela de novo template 
  #   com um alerta quanto ao preenchimento do campo.
  # - criação um novo registro de Template no banco de dados.
  # - redirecionamento para a página de criação com status de erro.
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
  # Argumentos:
  # - params: Um hash contendo os parâmetros da requisição HTTP com acesso externo permitido.
  # Não retorna valor.
  # Tem como efeitos colaterais a renderização da página 
  # de edição de template com o template selecionado.
  def edit
    @template = Template.find(params[:id])
    render layout: "home"
  end

  # Método para atualizar um template existente
  #
  # Argumentos:
  # - template_params: Um hash contendo os parâmetros da requisição HTTP com acesso externo permitido.
  # Não retorna valor.
  # Pode ter como efeitos colaterais: 
  # - redirecionamento para a tela de edição de template 
  #   com um alerta quanto ao preenchimento do campo.
  # - atualização de um registro de Template existente no banco de dados.
  # - redirecionamento para a página de edição com status de erro.
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

  # Método para excluir um template existente
  #
  # Argumentos:
  # - params: Um hash contendo os parâmetros da requisição HTTP.
  # Não retorna valor.
  # Tem como efeitos colaterais:
  # - mudança do atributo hidden do template selecionado para true 
  # - renderização da página com todos os templates após a deleção do template em questão.
  def destroy
    id = params[:id].to_i
    template = Template.find(id)
    template.update({ hidden: true })

    redirect_to templates_path, notice: 'Template deletado com sucesso!'
  end

  private

  # Define os parâmetros permitidos para a criação e atualização de templates
  #
  # Argumentos:
  # - params: Um hash contendo os parâmetros da requisição HTTP.
  # Não retorna valor
  # Tem como efeito colateral a permissão de acesso externo ao campo nome dos parâmetros
  def template_params
    params.require(:template).permit(:name)
  end
end
