require 'rails_helper'

RSpec.describe TemplatesController, type: :controller do
  describe "templates view" do
    let(:user) { FactoryBot.create(:user, admin: true) }

    before :each do
      sign_in user
    end

    it "renders index" do
      expect(response).to have_http_status(:ok)
      get :index
    end

    it "calls the model to create a new template" do
      expect(Template).to receive(:new)
      get :new
    end
  end

end