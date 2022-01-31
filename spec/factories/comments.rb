FactoryBot.define do
  factory :comment do
    description { Faker::Lorem.paragraph }
    user nil
    task nil
  end
end
