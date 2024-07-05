class ResultadosController < ApplicationController
  # Método para renderizar a página de índice de resultados
  #
  # Não recebe argumentos.
  # Não retorna valor.
  # Não possui efeitos colaterais além de renderizar a página com layout "home".
  def index
    @study_classes = StudyClass.all
    render layout: "home"
  end

  # Método placeholder para renderizar a página de detalhes de um resultado específico
  #
  # Não recebe argumentos.
  # Não retorna valor.
  # Não possui efeitos colaterais.
  def show

  end

  # Método para exportar resultados de um estudo em formato CSV
  #
  # Argumentos:
  # - params[:id]: ID da classe de estudo cujos resultados serão exportados.
  #
  # Não retorna valor explícito.
  # Pode ter efeitos colaterais: gera um arquivo CSV para download, define uma mensagem de flash de sucesso e redireciona o usuário.
  def export
    study_class = StudyClass.find(params[:id])
    forms = FormResponse.find_with_study_class(study_class)

    if forms.length == 0
      flash[:notice] = "Nenhum formulário respondido."
      redirect_to "/gerenciamento/resultados"
      return
    end

    csv = FormResponse.to_csv(forms)

    send_data csv, filename: "respostas-#{study_class.name}-#{Date.today}.csv"

    flash[:notice] = "Relatório baixado com sucesso."
  end
end
