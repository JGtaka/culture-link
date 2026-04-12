FactoryBot.define do
  factory :choice do
    body { "フィレンツェ" }
    correct_answer { false }
    association :question
  end
end
