require 'rails_helper'

RSpec.describe Task, type: :model do
  # Association test
  # ensure an item record belongs to a single todo record
  it { should belong_to(:project) }
  it { should have_many(:comments).dependent(:destroy) }
  # Validation test
  # ensure column name is present before saving
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
end
