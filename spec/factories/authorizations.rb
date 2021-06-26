FactoryBot.define do
  factory :authorization do
    user
    provider { "MyString" }
    uid { "123" }

    trait :github do
      provider { "github" }
    end

    trait :vkontakte do
      provider { "vkontakte" }
    end
  end
end
