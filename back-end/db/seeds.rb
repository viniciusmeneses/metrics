# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

metrics = [
  Metric.create(name: "Signups"),
  Metric.create(name: "New Customers"),
  Metric.create(name: "Upsells")
]

metrics.each do |metric|
  random_records = 1000.times.map do
    {
      metric_id: metric.id,
      timestamp: Faker::Time.backward,
      value: Faker::Number.between(from: 5, to: 500)
    }
  end

  Record.insert_all(random_records)
end
