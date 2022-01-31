FactoryBot.define do
  factory :project do
    name { Faker::Job.title }
    description { Faker::Lorem.paragraph }
    status false
    user nil
  end
end
