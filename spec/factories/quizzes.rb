FactoryBot.define do
  factory :quiz do
    sequence(:title) { |n| "小テスト#{n}" }
    image_url { "/quiz_images/sample.jpg" }
    association :quiz_category
  end
end
