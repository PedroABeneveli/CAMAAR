class TemplatesController < ApplicationController
  def index
    @templates = Template.all
    render layout: "home"
  end

  def new
    @template = Template.new
    render layout: "home"
  end

  def create

  end

  def edit
    @template = Template.find(params[:id])
    # Do things here to set the template
    render layout: "home"
  end

  def update

  end

  def destroy
    @template.destroy
    redirect_to templates_path, notice: 'Template was successfully deleted.'
  end

  def question_add
    puts "aaaaaaaa"
    @template.template_questions << TemplateQuestion.new
  end

  private

  def template_params
    params.require(:template).permit(
      :name,
      template_questions_attributes: [:id, :title, :question_type, :content, :_destroy, alternatives: [:content]]
    )
  end
end
