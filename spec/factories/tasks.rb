FactoryBot.define do
  factory :task do
    name { Faker::Job.title }
    description { Faker::Lorem.paragraph }
    deadline { Faker::Date.between(from: '2022-01-01', to: '2022-12-31') }
    project nil 
    status  false 
  end
end
