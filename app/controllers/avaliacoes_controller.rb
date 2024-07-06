# Controlador responsável pelo tratamento das requisições referentes 
# à view de visualização de formulários
class AvaliacoesController < ApplicationController
  before_action :authenticate_user!

  # Lista os formulários pendentes do usuário atual.
  #
  # Não retorna valor.
  # Tem como efeito colateral a renderização da página com os formulários disponíveis
  def index
    @forms = current_user.find_pending_forms
    render layout: "home"
  end
end
