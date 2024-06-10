require 'bcrypt'

class User < ApplicationRecord
  has_secure_password
  validates :email, :matricula, :password, :tipo, presence: true
  validates :email, :matricula, uniqueness: true
end
