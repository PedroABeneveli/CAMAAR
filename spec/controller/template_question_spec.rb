require 'rails_helper'

RSpec.describe TemplateQuestionController, type: :controller do
  describe "add question" do
    let(:user) { FactoryBot.create(:user, admin: true) }

    before :each do
      sign_in user
    end

    it "find the current template" do
      template = double("template")
      expect(Template).to receive(:find).with(17).and_return(template)
      allow(template).to receive(:template_questions).and_return([])
      allow(template).to receive(:save!)

      post :create, params: { template_id: "17" }
    end

    it "should create a new template question" do
      template = double("template")
      template_question = double("template_question")
      allow(Template).to receive(:find).with(17).and_return(template)
      allow(template).to receive(:template_questions).and_return([])
      allow(template).to receive(:save!)

      expect(TemplateQuestion).to receive(:create).and_return(template_question)

      post :create, params: { template_id: "17" }
    end

  end
end