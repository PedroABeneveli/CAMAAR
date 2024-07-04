class TemplateQuestionController < ApplicationController
  def create
    template_id = params[:template_id].to_i

    @template = Template.find(template_id)
    @template.template_questions << TemplateQuestion.create(question_type: "text", title: "", content: "")
    @template.save!

    redirect_to edit_template_path(template_id)
  end
end
