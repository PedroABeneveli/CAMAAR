require 'rails_helper'

RSpec.describe TemplateQuestionController, type: :controller do
  describe "template questions" do
    let(:user) { FactoryBot.create(:user, admin: true) }
    let(:template) { FactoryBot.create(:template) }

    before :each do
      sign_in user
    end

    it "finds the current template" do
      expect(Template).to receive(:find)
      get :new, params: { :template_id => template.id }
    end
  end

end