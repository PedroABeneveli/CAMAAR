require 'rails_helper'

RSpec.describe Template, type: :model do
  describe "all_visible method" do
    it "should exist" do
      expect(Template).to respond_to(:all_visible)
    end

    it "should find only visible templates" do
      expect(Template).to receive(:where).with({ hidden: false })
      Template.all_visible
    end
  end
end
