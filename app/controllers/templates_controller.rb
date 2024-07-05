class TemplatesController < ApplicationController
  def index
    @templates = Template.all_visible
    render layout: "home"
  end

  def new
    @template = Template.new
    render layout: "home"
  end

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

  def edit
    @template = Template.find(params[:id])
    render layout: "home"
  end

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

  def template_params
    params.require(:template).permit(:name)
  end
end
