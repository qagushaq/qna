FactoryBot.define do
  factory :comment do
    body { "Comment Text" }

    trait :invalid do
      body { nil }
    end
  end
end
