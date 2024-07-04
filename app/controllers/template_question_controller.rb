class TemplateQuestionController < ApplicationController
  def create
    @template = Template.find(params[:template_id].to_i)
    @template.template_questions << TemplateQuestion.create(question_type: "text", title: "", content: "")
    @template.save!
  end
end
