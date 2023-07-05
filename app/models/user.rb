# frozen_string_literal: true

# User class
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  has_many :movies, dependent: :destroy
  has_many :reviews, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :jwt_authenticatable, jwt_revocation_strategy: self

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, presence: true

  validates :password, presence: true,
                       length: { minimum: 8 },
                       format: {
                         with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}\z/,
                         message: I18n.t('models.user_model.validation.password_message')
                       }

  def send_instructions(confirmation_token)
    UserMailer.confirmation_instructions(self, confirmation_token).deliver
  end
end
