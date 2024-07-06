# Controlador responsável pelo tratamento das requisições referentes 
# à view de resultados de respostas de formulários
class ResultadosController < ApplicationController

  # Método para renderizar a página de resultados
  #
  # Não recebe argumentos.
  # Não retorna valor.
  # Tem como efeito colateral a renderização da página de resultados
  def index
    @study_classes = StudyClass.all
    render layout: "home"
  end

  # Método para exportar resultados das respostas em formato CSV
  #
  # Argumentos:
  # - params[:id]: ID da classe de estudo cujos resultados serão exportados.
  #
  # Não retorna valor explícito.
  # Pode ter efeitos colaterais: 
  # - gera um arquivo CSV para download
  # - define uma mensagem de flash de sucesso 
  # - redireciona o usuário para a página de resultados
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