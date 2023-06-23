class User < ApplicationRecord
  

  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'must be a valid email address' }
  validates :password, length: { minimum: 6 }, allow_nil: true
end
