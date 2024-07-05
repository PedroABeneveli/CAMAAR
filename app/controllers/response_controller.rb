# Controlador responsável pelo tratamento das requisições referentes 
# à view de preenchimento e envio de um formulário
class ResponseController < AvaliacoesController

  # Método para renderizar a página do template
  #
  # Não recebe argumentos.
  # Não retorna valor.
  # Tem como efeito colateral a renderização da página do template
  def index
    @form_request = FormRequest.find(params[:avaliaco_id])
    render layout: "home"
  end

  # Método para criar uma nova resposta ao formulário
  #
  # Argumentos:
  # - params: Um hash contendo os parâmetros da requisição HTTP.
  #
  # Não retorna valor explícito.
  # Pode ter efeitos colaterais: 
  # - criação de um novo registro de FormResponse no banco de dados
  # - marcação do FormRequest como respondido (answered = true) 
  # - redirecionamento a página de avaliações
  def create
    @form_request = FormRequest.find(params[:avaliaco_id])

    answers = []
    params.each do |name, value|
      if name.start_with?("answer_")
        if value == ""
          flash[:alert] = "Por favor, responda todas as perguntas obrigatórias"
          redirect_to "/avaliacoes/#{@form_request.id}/response"
          return
        end

        answers << value
      end
    end

    @form_response = FormResponse.new
    @form_response.study_class = @form_request.study_class
    @form_response.template = @form_request.template
    @form_response.response = answers.to_json
    @form_response.save!

    @form_request.answered = true
    @form_request.save!

    flash[:notice] = "Obrigado pelas respostas"
    redirect_to "/avaliacoes"
  end
end
