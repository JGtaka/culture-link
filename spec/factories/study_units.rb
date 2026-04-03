FactoryBot.define do
  factory :study_unit do
    sequence(:name) { |n| "単元#{n}" }
  end
end
