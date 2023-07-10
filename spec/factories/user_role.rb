FactoryBot.define do
  factory :user_role do
    user { FactoryBot.build(:user) }
    role { FactoryBot.build(:role) }
  end
end
