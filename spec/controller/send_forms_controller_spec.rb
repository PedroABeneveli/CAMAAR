require 'rails_helper'

RSpec.describe SendFormsController, type: :controller do
  let(:user) { FactoryBot.create(:user, admin: true) }

  before :each do
    sign_in user
  end

  describe "#index" do
    it "renders index" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "#create" do
    it "should find the selected template" do
      template = double("template")
      expect(Template).to receive(:find).with(17).and_return(template)

      post :create, params: { template: "17" }
    end
  end
end