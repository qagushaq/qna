FactoryBot.define do
  factory :answer do
    body { "Answer Text" }
    question
    user
    best { false }

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      files { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }
    end

    trait :with_link do
      after(:create) do |question|
        create :link, linkable: answer
      end
    end
  end
end
