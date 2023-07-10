FactoryBot.define do
  factory :course do
    title { Faker::Name.name_with_middle }
    description { Faker::Markdown.emphasis  }
  end
end
