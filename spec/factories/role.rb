FactoryBot.define do
  factory :role do
    name { ["admin", "school_admin", "student"].sample }
  end
end
