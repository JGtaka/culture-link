FactoryBot.define do
  factory :schedule do
    user
    start_date { Date.today }
    end_date { Date.today + 30.days }
    daily_study_hours { 2 }
    weekdays { [0, 1, 2, 3, 4] }
    memo { "頑張って学習する" }
  end
end
