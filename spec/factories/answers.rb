FactoryBot.define do
  factory :answer do
    sequence :body do |n|
      "AnswerBody#{n}"
    end

    trait :invalid do
      body { nil }
    end
  end
end
