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
    question_type = template_question_params[:question_type]
    title = template_question_params[:title]

    if TemplateQuestion.question_types.values.include?(question_type)
      flash[:notice] = "Successfully updated question!"

      if question_type == "text"
        @template_question.update(question_type: "text", title: title, content: "")
      elsif question_type == "radio" or question_type == "checkbox"
        alternatives = []
        1.upto(10) do |i|
          if template_question_params.key?("alternative_#{i}")
            alternatives << template_question_params["alternative_#{i}"]
          else
            break
          end
        end

        @template_question.update(question_type: question_type, title: title, content: alternatives.to_json)
      else
        flash[:alert] = "Question type #{question_type} does not exist!"
      end
    else
      redirect_to edit_template_path(id)
    end
  end

  def add_alternative
    id = params[:template_question_id].to_i
    @template_question = TemplateQuestion.find(id)
  end
end
