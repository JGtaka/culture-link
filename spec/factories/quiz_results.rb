FactoryBot.define do
  factory :quiz_result do
    association :user
    association :quiz
    status { :in_progress }
    score { 0 }
    correct_count { 0 }
    total_correct { 0 }
    test_date { Date.current }
  end
end
