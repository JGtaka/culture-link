FactoryBot.define do
  factory :region do
    sequence(:name) { |n| "地域#{n}" }
  end
end
