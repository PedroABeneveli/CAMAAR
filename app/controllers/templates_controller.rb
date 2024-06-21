class TemplatesController < ApplicationController
    before_action :set_template, except: [:index, :new, :create]
  
    def index 
      @templates = Template.all
    end
  
    def show
    end
  
    def new
      @template = Template.new
      @template.template_questions.build
    end
  
    def create 
      process_alternatives
      @template = Template.new(template_params)
      if @template.save
        redirect_to templates_path
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
    end
  
    def update 
      process_alternatives
      if @template.update(template_params)
        redirect_to templates_path
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy 
      @template.destroy
      redirect_to templates_path 
    end
  
    private
  
    def template_params
      params.require(:template).permit(
        :name, 
        template_questions_attributes: [:id, :title, :question_type, :content, :_destroy]
      )
    end
  
    def set_template
      @template = Template.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to templates_path
    end
  
    def process_alternatives
      return unless params[:template][:template_questions_attributes]
  
      params[:template][:template_questions_attributes].each do |key, question|
        if question[:question_type] == 'radio' && params[:template][:template_questions_attributes][key][:alternatives].present?
          alternatives = params[:template][:template_questions_attributes][key][:alternatives].map { |alt| alt[:content] }
          params[:template][:template_questions_attributes][key][:content] = alternatives.to_json
        elsif question[:question_type] != 'radio'
          params[:template][:template_questions_attributes][key][:content] = question[:content]
        else
          params[:template][:template_questions_attributes][key][:content] = '[]' # Empty JSON array if no alternatives
        end
      end
    end
  end
  