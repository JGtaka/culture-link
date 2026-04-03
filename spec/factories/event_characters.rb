FactoryBot.define do
  factory :event_character do
    association :event
    association :character
  end
end
