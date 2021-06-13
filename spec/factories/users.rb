FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
  end

  trait :with_awards do
    after(:create) do |user|
      create_list(:award, 2, user: user)
    end
  end
end
