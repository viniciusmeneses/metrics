module Records
  class Create < Micro::Case
    attribute :timestamp
    attribute :value
    attribute :metric_id

    validates :timestamp, kind: String
    validates :value, kind: Numeric
    validates :metric_id, kind: Integer

    def call!
      record = Record.create!(timestamp:, value:, metric_id:)
      Success(result: { record: })
    rescue ActiveRecord::RecordInvalid => error
      Failure(:invalid_record, result: { errors: error.record.errors })
    end
  end
end
