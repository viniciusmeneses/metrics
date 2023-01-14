# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

return if Metric.exists?

metrics = [
  Metric.create(name: "Payments"),
  Metric.create(name: "Signups"),
]

metrics.each do |metric|
  from_value = (rand * 100).to_i
  to_value = (rand * 100).to_i + from_value

  random_records = 500.times.map do
    {
      metric_id: metric.id,
      timestamp: Faker::Time.backward,
      value: Faker::Number.between(from: from_value, to: to_value)
    }
  end

  Record.insert_all(random_records)
end
