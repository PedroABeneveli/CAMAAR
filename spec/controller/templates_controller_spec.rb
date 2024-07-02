require 'rails_helper'

RSpec.describe TemplatesController, type: :controller do
  describe "templates view" do
    let(:user) { FactoryBot.create(:user, admin: true) }

    before :each do
      sign_in user
    end

    describe "#index" do
      it "renders index" do
        get :index
        expect(response).to have_http_status(:ok)
      end

      it "gets all templates on index" do
        expect(Template).to receive(:all)
        get :index
      end
    end

    describe "#new" do
      it "renders new" do
        get :new
        expect(response).to render_template(:new)
      end

      it "calls the model to create a new template" do
        expect(Template).to receive(:new)
        get :new
      end
    end

    describe "add question action" do
      it "should have an question_add method" do
        expect(controller).to respond_to(:question_add)
      end

      it "should have a redirect to question_add method" do
        expect(put: '/gerenciamento/templates/13/question_add').to route_to(
                                                                     controller: 'templates',
                                                                     action: 'question_add',
                                                                     id: '13'
                                                                   )
      end

      it "should find the current template" do
        expect(Template).to receive(:find).and_return(double(Template))
        put :question_add, params: { :id => 17 }
      end

      it "should create a new template question" do
        template_mock = double("Template")

        allow(Template).to receive(:find).with(17).and_return(template_mock)
        allow(template_mock).to receive(:template_questions).and_return([])

        expect(TemplateQuestion).to receive(:new).and_return(double(TemplateQuestion))
        put :question_add, params: { :id => 17 }
      end
    end
  end

end