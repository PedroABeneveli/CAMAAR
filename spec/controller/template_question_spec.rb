require 'rails_helper'

RSpec.describe TemplateQuestionController, type: :controller do
  let(:user) { FactoryBot.create(:user, admin: true) }

  before :each do
    sign_in user
  end

  describe "add question" do
    it "should find the current template" do
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

  describe "edit question" do
    it "should find the current template question" do
      template_question = double("template_question")
      expect(TemplateQuestion).to receive(:find).with(13).and_return(template_question)
      expect(template_question).to receive(:update)

      post :update, params: { template_id: "17", id: "13", template_question: { title: "Q1", question_type: "text" } }
    end

    it "should update the question - text type" do
      template_question = double("template_question")
      allow(TemplateQuestion).to receive(:find).with(13).and_return(template_question)
      expect(template_question).to receive(:update).with({ title: "Q1", question_type: "text", content: "" })

      post :update, params: { template_id: "17", id: "13", template_question: { title: "Q1", question_type: "text" } }
    end

    it "should update the question - radio type" do
      template_question = double("template_question")
      allow(TemplateQuestion).to receive(:find).with(13).and_return(template_question)
      expect(template_question).to receive(:update).with({ title: "Q1", question_type: "radio", content: "[\"1\",\"2\",\"3\"]" })

      post :update, params: { template_id: "17", id: "13", template_question: { title: "Q1", question_type: "radio", alternative_1: "1", alternative_2: "2", alternative_3: "3" } }
    end

    it "should update the question - checkbox type" do
      template_question = double("template_question")
      allow(TemplateQuestion).to receive(:find).with(13).and_return(template_question)
      expect(template_question).to receive(:update).with({ title: "Q1", question_type: "checkbox", content: "[\"1\",\"2\",\"3\"]" })

      post :update, params: { template_id: "17", id: "13", template_question: { title: "Q1", question_type: "checkbox", alternative_1: "1", alternative_2: "2", alternative_3: "3" } }
    end

    describe "add alternative" do
      it "should find the current template question" do
        template_question = double("template_question")
        expect(TemplateQuestion).to receive(:find).with(13).and_return(template_question)

        post :add_alternative, params: { template_id: "17", template_question_id: "13" }
      end
    end
  end
end