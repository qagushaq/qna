FactoryBot.define do
  factory :answer do
    body { "Answer Text" }
    question
    user
    best { false }


    trait :invalid do
      body { nil }
    end
  end
end
