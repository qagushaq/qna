FactoryBot.define do
  factory :question do
    title { "Question String" }
    body { "Question Text" }
    user

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      files { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }
    end

    trait :with_link do
      after(:create) do |question|
        create :link, linkable: question
      end
    end

    trait :with_award do
      after(:create) do |question|
        create :award, question: question
      end
    end

    trait :with_award_and_answer do
      after(:create) do |question|
        create :award, question: question
        create :answer, question: question
      end
    end
  end
end
