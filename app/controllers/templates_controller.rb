class TemplatesController < ApplicationController
    before_action :set_controller, except: [:index, :new, :create]
    def index 
        @templates = Template.all
    end

    def show
    end

    def new
        @template = Template.new
    end

    def create 
        @template = Template.new(template_params)
        if @template.save
            redirect_to @template
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update 
        if @template.update(template_params)
            redirect_to @template
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy 
        @template.destroy
        redirect_to root_path   
    end

    private

    def template_params
        params.require(:template).permit(:name, :content)
    end

    def set_template
        @template = Template.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to root_path
    end
end