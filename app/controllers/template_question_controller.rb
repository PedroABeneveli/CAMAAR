class TemplateQuestionController < ApplicationController
  def create
    template_id = params[:template_id].to_i

    @template = Template.find(template_id)
    @template.template_questions << TemplateQuestion.create(question_type: "text", title: "", content: "")
    @template.save!

    redirect_to edit_template_path(template_id)
  end

  def update
    id = params[:id].to_i
    @template_question = TemplateQuestion.find(id)

    template_question_params = params[:template_question]
    if template_question_params[:question_type] == "text"
      @template_question.update(question_type: "text", title: template_question_params[:question], content: "")
    elsif template_question_params[:question_type] == "radio"
      @template_question.update(question_type: "radio", title: template_question_params[:question], content: template_question_params[:alternatives].to_json)
    elsif template_question_params[:question_type] == "checkbox"
      @template_question.update(question_type: "checkbox", title: template_question_params[:question], content: template_question_params[:alternatives].to_json)
    else
      flash[:alert] = "Question type #{template_question_params[:question_type]} does not exist!"
      redirect_to edit_template_path(params[:template_id])
    end
  end
end
