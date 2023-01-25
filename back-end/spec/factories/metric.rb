FactoryBot.define do
  factory :metric do
    name { "Metric" }

    trait :with_records do
      records { [association(:record), association(:record)] }
    end
  end
end
