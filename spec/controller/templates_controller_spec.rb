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
      it "renders show" do
        get :new
        expect(response).to render_template("templates/show")
      end
    end

    describe "#show" do
      it "renders show template" do
        expect(response).to render_template('templates/new')
        get :show, params: { id: 1 }
      end
    end

    it "calls the model to create a new template" do
      expect(Template).to receive(:new)
      get :new
    end
  end

end