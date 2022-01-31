class CommentFile < ApplicationRecord
  belongs_to :comment

  # validations
  validates_presence_of :url
end
