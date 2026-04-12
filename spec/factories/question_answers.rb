FactoryBot.define do
  factory :question_answer do
    association :quiz_result
    association :question
    association :choice
    is_correct { false }
  end
end
