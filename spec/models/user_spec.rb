require 'rails_helper'

describe User, type: :model do
  it "should exist" do
    expect { User }.not_to raise_error
  end

  describe "logging in" do
    it "should validate a password" do
      @user = User.create(email: "alice@email.com", matricula: "1234", password: "pass123", tipo: "aluno", is_admin: false)
      expect(@user.authenticate("passabc")).to be_falsy
      expect(@user.authenticate("pass123")).to be_truthy
    end
  end
end
