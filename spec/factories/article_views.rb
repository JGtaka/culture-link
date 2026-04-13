FactoryBot.define do
  factory :article_view do
    association :user
    association :article, factory: :event
  end
end
