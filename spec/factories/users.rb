FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }

    trait :google_user do
      provider { "google_oauth2" }
      sequence(:uid) { |n| "google-uid-#{n}" }
    end

    trait :admin do
      role { :admin }
    end
  end
end
