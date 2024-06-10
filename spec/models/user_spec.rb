require 'rails_helper'

describe User, type: :model do
  it "should exist" do
    expect { User }.not_to raise_error
  end

  describe "logging in" do
    user = FactoryBot.build(:user)

    it "should validate a password" do
      expect(user.authenticate("pass456")).to be_falsy
      expect(user.authenticate("pass123")).to be_truthy
    end
  end
end
