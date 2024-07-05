##
# O controlador AvaliacoesController gerencia as avaliações dos usuários.
# Exige autenticação do usuário para todas as ações.
class AvaliacoesController < ApplicationController
  before_action :authenticate_user!

  ##
  # Lista os formulários pendentes do usuário atual.
  #
  # @return [void] Não retorna um valor diretamente.
  # @effect Define a variável de instância @forms e renderiza a página com o layout "home".
  def index
    @forms = current_user.find_pending_forms
    render layout: "home"
  end
end
