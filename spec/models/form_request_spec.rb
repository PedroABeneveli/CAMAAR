require 'rails_helper'

RSpec.describe FormRequest, type: :model do
  describe "send new form request" do
    it "should have a send method" do
      expect(FormRequest).to respond_to(:send_form).with(3).arguments
    end

    it "should try to find if already exists" do
      tpt = double("template")
      usr = double("user")
      sc = double("study_class")

      expect(FormRequest).to receive(:find_by).with({ template_id: 10, user_id: 20, study_class_id: 30 }).and_return(nil)
      allow(tpt).to receive(:id).and_return(10)
      allow(usr).to receive(:id).and_return(20)
      allow(sc).to receive(:id).and_return(30)

      allow(FormRequest).to receive(:create)

      FormRequest.send_form(tpt, usr, sc)
    end

    it "should create a new request when it doesn't exist" do
      tpt = double("template")
      usr = double("user")
      sc = double("study_class")

      allow(FormRequest).to receive(:find_by).with({ template_id: 10, user_id: 20, study_class_id: 30 }).and_return(nil)
      allow(tpt).to receive(:id).and_return(10)
      allow(usr).to receive(:id).and_return(20)
      allow(sc).to receive(:id).and_return(30)

      expect(FormRequest).to receive(:create).with({ template: tpt, user: usr, study_class: sc })

      FormRequest.send_form(tpt, usr, sc)
    end

    it "should not create a new request when it does exist" do
      tpt = double("template")
      usr = double("user")
      sc = double("study_class")

      fr = double("form_request")
      allow(fr).to receive(:is_nil?).and_return(false)

      allow(FormRequest).to receive(:find_by).with({ template_id: 10, user_id: 20, study_class_id: 30 }).and_return(fr)
      allow(tpt).to receive(:id).and_return(10)
      allow(usr).to receive(:id).and_return(20)
      allow(sc).to receive(:id).and_return(30)

      expect(FormRequest).not_to receive(:create).with({ template: tpt, user: usr, study_class: sc })

      FormRequest.send_form(tpt, usr, sc)
    end
  end
end
