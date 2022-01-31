require 'rails_helper'

RSpec.describe Comment, type: :model do
  # Association test
  # ensure an item record belongs to a single todo record
  it { should belong_to(:task) }
  it { should belong_to(:user) }
  
  it { should have_many(:comment_files).dependent(:destroy) }
  
  # Validation test
  # ensure column name is present before saving
  it { should validate_presence_of(:description) }
end
