FactoryBot.define do
  factory :award do
    title { "Award title" }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/award.jpg'), 'image/jpeg') }
    question
  end
end
