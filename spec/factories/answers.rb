FactoryBot.define do
  factory :answer do
    body { "Answer Text" }
    question
    user

    trait :invalid do
      body { nil }
    end
  end
end
