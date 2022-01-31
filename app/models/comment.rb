class Comment < ApplicationRecord
  # model association
  belongs_to :task
  belongs_to :user
  has_many :comment_files, dependent: :destroy

  # validations
  validates_presence_of :description
end
