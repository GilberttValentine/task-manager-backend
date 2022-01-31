class Task < ApplicationRecord
  # model association
  belongs_to :project
  has_many :comments, dependent: :destroy
  
  # validations
  validates_presence_of :name, :description, :deadline
end
