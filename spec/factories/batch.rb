FactoryBot.define do
  factory :batch do
    name { Faker::Name.name_with_middle }
    description { Faker::Markdown.emphasis  }
  end
end
