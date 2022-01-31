class Project < ApplicationRecord
  # model association
  belongs_to :user
  has_many :tasks, dependent: :destroy

  # validations
  validates_presence_of :name, :description
end
