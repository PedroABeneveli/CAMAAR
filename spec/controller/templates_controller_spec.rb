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
        expect(Template).to receive(:all_visible)
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

      it "handles empty field" do
        post :create, :params => { :template => { :name => ""} } 

        expect(response).to redirect_to(new_template_path)
        expect(flash[:alert]).to eq("Nome do template em branco!")
      end
    end

    describe "#edit" do
      let(:template) { FactoryBot.create(:template) }

      it "renders the edit template" do
        get :edit, params: { id: template.id }
        expect(response).to render_template(:edit)
      end
    end

    describe "#update" do
      let(:template) { FactoryBot.create(:template) }
      
      it "updates template" do
        post :update, :params => { :id => template.id, :template => { :name => "Template #2" } }

        expect(template.reload.name).to eq("Template #2")
      end

      it "handles empty field" do
        post :update, params: { template: { name: ""}, id: template.id }
        
        expect(response).to redirect_to(edit_template_path(template.id))
        expect(flash[:alert]).to eq("Nome do template em branco!")
      end
    end

    describe "#delete" do
      it "finds current template" do
        template = double("template")
        expect(Template).to receive(:find).with(17).and_return(template)
        allow(template).to receive(:update).with({ hidden: true })

        post :destroy, :params => { :id => "17" }
      end

      it "updates template with destroyed true" do
        template = double("template")
        allow(Template).to receive(:find).with(17).and_return(template)
        expect(template).to receive(:update).with({ hidden: true })

        post :destroy, :params => { :id => "17" }
      end
    end
  end
end