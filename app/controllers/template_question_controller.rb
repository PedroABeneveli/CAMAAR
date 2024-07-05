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
      flash[:notice] = "Template atualizado com sucesso!"

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
        flash[:alert] = "Questão de tipo #{question_type} não existe!"
      end
    end

    redirect_to edit_template_path(id)
  end

  def add_alternative
    id = params[:template_question_id].to_i
    @template_question = TemplateQuestion.find(id)

    alternatives = JSON.parse @template_question.content
    alternatives << ""

    @template_question.update({ content: alternatives.to_json })

    redirect_to edit_template_path(id)
  end
end
