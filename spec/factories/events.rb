FactoryBot.define do
  factory :event do
    title { "モナ・リザの制作" }
    year { 1503 }
    association :period
    association :category
    description { "レオナルド・ダ・ヴィンチによる油彩画" }
    association :study_unit
    association :region
  end
end
