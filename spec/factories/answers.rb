FactoryBot.define do
  factory :answer do
    body { "MyBody" }

    trait :invalid do
      body { nil }
    end
  end
end
