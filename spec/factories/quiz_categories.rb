FactoryBot.define do
  factory :quiz_category do
    sequence(:name) { |n| "カテゴリ#{n}" }
  end
end
