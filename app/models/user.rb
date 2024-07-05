# Modelo que representa um usuário no sistema, utilizando o framework Devise para autenticação.
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :registrable, :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  # Validação do formato da matrícula, garantindo que contenha apenas números.
  validates_format_of :matricula, with: /[0-9]*/

  # Permite definir um atributo de escrita para o login.
  attr_writer :login

  # Associações
  #   - Tem e pertence a muitas classes de estudo, permitindo a associação de vários usuários a várias classes de estudo.
  has_and_belongs_to_many :study_classes
  has_many :form_requests

  # Retorna o login do usuário, preferencialmente usando a matrícula ou o email.
  # 
  # Retorna:
  #   - Uma string contendo o login do usuário, utilizando a matrícula se definida, senão o email.
  def login
    @login || self.matricula || self.email
  end

  # Encontra todas as requisições de formulário pendentes para este usuário.
  # 
  # Retorna:
  #   - Um objeto ActiveRecord::Relation contendo todas as requisições de formulário pendentes para este usuário.
  def find_pending_forms
    FormRequest.where(user_id: self.id, answered: false)
  end

  # Método interno do Devise para encontrar o usuário durante a autenticação no banco de dados.
  # 
  # Argumentos:
  #   - warden_conditions: Condições usadas para autenticação pelo Warden.
  # 
  # Retorna:
  #   - O primeiro usuário que corresponde às condições fornecidas, comparando matrícula ou email em minúsculas.
  def self.find_for_database_authentication(warden_conditions)
    # Não criamos testes para esse método, pois é uma funcionalidade 
    # própria do Devise para permitir autenticação tanto com e-mail 
    # quanto com matrícula
    
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(["matricula = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:matricula) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  # Método para permitir a criação de usuários sem a necessidade de preencher o campo de senha.
  attr_accessor :skip_password_validation

  def self.add_student(hash)
    pessoa = User.new nome: hash["nome"], curso: hash["curso"], matricula: hash["matricula"], usuario: hash["usuario"], formacao: hash["formacao"], ocupacao: hash["ocupacao"], email: hash["email"]
    pessoa.skip_password_validation = true
    pessoa.save
    pessoa.send_reset_password_instructions

    pessoa
  end

  def self.add_teacher(hash)
    pessoa = User.new nome: hash["nome"], departamento: hash["departamento"], formacao: hash["formacao"], matricula: hash["usuario"], usuario: hash["usuario"], email: hash["email"], ocupacao: hash["ocupacao"]
    pessoa.skip_password_validation = true
    pessoa.save
    pessoa.send_reset_password_instructions

    pessoa
  end

  protected

  # Verifica se a validação de senha é necessária durante a criação ou atualização do usuário.
  # 
  # Retorna:
  #   - Um booleano indicando se a validação de senha é necessária ou não.
  def password_required?
    return false if skip_password_validation
    super
  end
end
