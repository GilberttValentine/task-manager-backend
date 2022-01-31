FactoryBot.define do
  factory :comment_file do
    url { Faker::Job.title }
    comment { nil }
  end
end
