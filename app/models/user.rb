class User < ApplicationRecord
  # encrypt password
  has_secure_password
  
  # model association
  has_many :projects, dependent: :destroy
  
  # validations
  validates_presence_of :name, :email, :password_digest
  validates :email, uniqueness:true
end
