require 'rails_helper'

RSpec.describe ResponseController, type: :controller do
    describe "response view" do
        describe "correct response" do
            let(:user) { FactoryBot.create(:user, admin: false) }
            let(:form_request) { FactoryBot.create(:form_request) }

            before :each do
                sign_in user
            end

            it "renders index" do
                expect(response).to have_http_status(:ok)
                get :index, :params => { :avaliaco_id => form_request.id }
            end

            it "answers form" do 
                expect {
                    post :create, :params => { :avaliaco_id => form_request.id, :answer_1 => "bla bla bla", :answer_2 => "bla bla"}
                }.to change(FormResponse, :count).by(1)
            end
        end
    end

end