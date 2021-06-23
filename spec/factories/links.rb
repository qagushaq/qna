FactoryBot.define do
  factory :link do
    name { "Mail" }
    url { "https://mail.ru/" }

    trait :invalid do
      url { "url" }
    end
  end
end
