class User < ApplicationRecord
  attr_accessor :remember_token
  USER_PARAMS = %i(name email password password_confirmation).freeze

  before_save{self.email = email.downcase}
  validates :name, presence: true,
    length: {maximum: Settings.validate.name_length}
  validates :email, presence: true,
    length: {maximum: Settings.validate.email_length},
    format: {with: Settings.validate.regex_email},
    uniqueness: {case_sensitive: true}
  validates :password, presence: true,
    length: {minimum: Settings.validate.password_min_length}
  has_secure_password

  class << self
    def diggest string
      if cost = ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
        BCrypt::Password.create string, cost: cost
      end
    end
  end
end
