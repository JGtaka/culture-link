FactoryBot.define do
  factory :question do
    body { "ルネサンス発祥の地はどこか？" }
    association :quiz
  end
end
