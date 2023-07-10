FactoryBot.define do
  factory :address do
    location { Faker::Address.community }
    city { Faker::Address.city  }
    state { Faker::Address.state  }
    pincode { Faker::Address.postcode  }
  end
end
