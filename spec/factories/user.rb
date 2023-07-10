FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    phone { Faker::Number.number }
    password { Faker::Internet.password }
    name { Faker::Lorem.unique.characters(number: 10) }
  end
end
