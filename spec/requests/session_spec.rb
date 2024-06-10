require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "should render page" do
      get "/login"
      expect(response).to render_template :login
    end
  end
end
