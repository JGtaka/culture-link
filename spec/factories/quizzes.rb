FactoryBot.define do
  factory :quiz do
    sequence(:title) { |n| "小テスト#{n}" }
    image_url { "/quiz_images/sample.jpg" }
    association :quiz_category

    trait :published do
      after(:create) do |quiz|
        quiz.questions.create!(body: "サンプル問題") if quiz.questions.none?
        quiz.update!(published_at: 1.day.ago)
      end
    end
  end
end
