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

    it "should find the selected classes" do
      template = double("template")
      allow(Template).to receive(:find).with(17).and_return(template)

      sc1 = double("sc1")
      sc3 = double("sc3")

      expect(StudyClass).to receive(:find).with(1).and_return(sc1)
      expect(StudyClass).to receive(:find).with(3).and_return(sc3)

      allow(sc1).to receive(:send_form_to_users)
      allow(sc3).to receive(:send_form_to_users)

      post :create, params: { template: "17", study_class_1: "1", study_class_3: "1" }
    end

    it "should send form to users for the selected classes" do
      template = double("template")
      allow(Template).to receive(:find).with(17).and_return(template)

      sc1 = double("sc1")
      sc3 = double("sc3")

      allow(StudyClass).to receive(:find).with(1).and_return(sc1)
      allow(StudyClass).to receive(:find).with(3).and_return(sc3)

      expect(sc1).to receive(:send_form_to_users)
      expect(sc3).to receive(:send_form_to_users)

      post :create, params: { template: "17", study_class_1: "1", study_class_3: "1" }
    end
  end
end