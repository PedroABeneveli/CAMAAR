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

    describe "#create" do
      it "creates new template" do
        expect {
          post :create, :params => { :template => { :name => "Template #1" } }
        }.to change(Template, :count).by(1)
      end
    end

    describe "#update" do
      it "updates template" do
        template = Template.create(name: "Template #1")

        post :update, :params => { :id => template.id, :template => { :name => "Template #2" } }

        expect(template.reload.name).to eq("Template #2")
      end
    end
  end
end