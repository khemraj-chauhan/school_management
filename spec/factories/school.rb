FactoryBot.define do
  factory :school do
    name { Faker::Name.name }

    after(:create) do |school, evaluator|
      create(:address, addressable: school)
    end
  end
end
