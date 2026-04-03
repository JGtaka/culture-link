FactoryBot.define do
  factory :character do
    sequence(:name) { |n| "人物#{n}" }
    description { "イタリアの芸術家・科学者" }
    achievement { "モナ・リザ、最後の晩餐などの傑作を制作" }
    association :study_unit
  end
end
