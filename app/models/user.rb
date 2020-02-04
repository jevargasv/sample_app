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
    length: {minimum: Settings.validate.password_min_length},
    allow_nil: true
  has_secure_password
  class << self
    def digest string
      if ActiveModel::SecurePassword.min_cost
        cost = BCrypt::Engine::MIN_COST
      else
        cost = BCrypt::Engine.cost
      end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return unless remember_digest
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attributes remember_digest: nil
  end
end
