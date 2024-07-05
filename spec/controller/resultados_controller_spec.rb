require 'rails_helper'

RSpec.describe ResultadosController, type: :controller do
  describe "resultados view" do
    describe "correct forms" do
      let(:user) { FactoryBot.create(:user, admin: true) }
      let(:study_class) { FactoryBot.create(:study_class) }

      before :each do
        sign_in user
      end

      it "renders index" do
        expect(response).to have_http_status(:ok)
        get :index
      end

      context "when there is at least one form response" do
        let(:form_responses) { [double('FormResponse')] }
        let(:csv_data) { "csv,data" }
  
        before do
          allow(FormResponse).to receive(:find_with_study_class).with(study_class).and_return(form_responses)
          allow(FormResponse).to receive(:to_csv).with(form_responses).and_return(csv_data)
        end
  
        it "sends the CSV data with the correct filename and sets the success notice" do
          get :export, params: { id: study_class.id }
  
          expect(response.header['Content-Disposition']).to include("filename=\"respostas-#{study_class.name}-#{Date.today}.csv\"")
          expect(response.body).to eq(csv_data)
          expect(flash[:notice]).to eq("Relatório baixado com sucesso.")
        end
      end

      context "when there is no form response" do 
        it "handles no form response" do
          allow(FormResponse).to receive(:find_with_study_class).with(study_class).and_return([])
          get :export, params: { id: study_class.id }

          expect(response).to redirect_to("/gerenciamento/resultados")
          expect(flash[:notice]).to eq("Nenhum formulário respondido.")
        end
      end
    end
  end

end