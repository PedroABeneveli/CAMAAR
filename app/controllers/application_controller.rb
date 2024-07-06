##
# ApplicationController é a classe base para todos os controladores do aplicativo.
# Configura parâmetros permitidos para Devise e redirecionamentos após ações de autenticação.
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  ##
  # Configura os parâmetros permitidos para as ações de sign up, sign in e account update do Devise.
  #
  # @return [void] Não retorna um valor.
  # @effect Configura os parâmetros permitidos para Devise.
  def configure_permitted_parameters
    added_attrs = [:matricula, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: [:login, :password]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  ##
  # Redireciona para a página de avaliações após o login.
  #
  # @param resource [Object] O usuário que fez login.
  # @return [String] URL de redirecionamento.
  # @effect Redireciona o usuário.
  def after_sign_in_path_for(resource)
    "/avaliacoes"
  end

  ##
  # Redireciona para a página de avaliações após redefinir a senha.
  #
  # @param resource [Object] O usuário que redefiniu a senha.
  # @return [String] URL de redirecionamento.
  # @effect Define mensagem flash e redireciona o usuário.
  def after_resetting_password_path_for(resource)
    flash[:notice] = "Senha registrada com sucesso"
    "/avaliacoes"
  end

  ##
  # Redireciona para a página de login após logout.
  #
  # @param resource [Object] O usuário que fez logout.
  # @return [String] URL de redirecionamento.
  # @effect Redireciona o usuário.
  def after_sign_out_path_for(resource)
    "/users/sign_in"
  end
end
