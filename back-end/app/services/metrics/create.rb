module Metrics
  class Create < Micro::Case
    attribute :name
    validates :name, kind: String

    def call!
      metric = Metric.create!(name:)
      Success(result: { metric: })
    rescue ActiveRecord::RecordInvalid => error
      Failure(:invalid_metric, result: { errors: error.record.errors })
    end
  end
end
