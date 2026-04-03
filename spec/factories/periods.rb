FactoryBot.define do
  factory :period do
    sequence(:name) { |n| "時代#{n}" }
  end
end
