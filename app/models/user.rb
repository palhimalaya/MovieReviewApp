# frozen_string_literal: true

# User class
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  has_many :movies, dependent: :destroy

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
                         message: 'must include at least one lowercase letter, one uppercase letter, one symbol and one numeric digit'
                       }
end
