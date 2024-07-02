require 'rails_helper'

RSpec.describe TemplateQuestionController, type: :controller do
  describe "template questions" do
    let(:user) { FactoryBot.create(:user, admin: true) }
    let(:template) { FactoryBot.create(:template) }

    before :each do
      sign_in user
    end

    it "finds the current template" do
      expect(Template).to receive(:find).with(template.id).and_return(template)
      get :new, params: { :template_id => template.id.to_s }
    end

    it "creates a new template question" do
      expect(TemplateQuestion).to receive(:new).and_return(TemplateQuestion.new)
      get :new, params: { :template_id => template.id.to_s }
    end
  end

end