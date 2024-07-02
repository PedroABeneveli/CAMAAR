class TemplateQuestionController < ApplicationController
  def new
    @template = Template.find(params[:template_id].to_i)
    if @template.nil?
      render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
      return
    end

    @template_question = TemplateQuestion.new
    @template_question.question_type = "text"

    @template.template_questions << @template_question

    render :template => "templates/new", :layout => "home"
  end

  def update
    if params[:type] == "text"
      @template_question.question_type = "text"
      @template_question.title = params[:title]
      @template_question.content = ""
    end
  end
end
