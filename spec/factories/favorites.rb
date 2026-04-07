FactoryBot.define do
  factory :favorite do
    user
    association :favorable, factory: :event
  end
end
