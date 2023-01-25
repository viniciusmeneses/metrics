FactoryBot.define do
  factory :record do
    timestamp { Date.yesterday }
    value { 5.30 }
    metric
  end
end
