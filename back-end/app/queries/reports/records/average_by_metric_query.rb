module Reports
  module Records
    class AverageByMetricQuery < Micro::Case
      attribute :metric_id
      attribute :group_by, default: :day

      validates :metric_id, kind: Integer, allow_nil: true
      validates :group_by, kind: Symbol, inclusion: { in: [:minute, :hour, :day] }

      def call!
        grouped_records = Record
          .select(
            :metric_id,
            "MIN(records.timestamp) AS start_timestamp",
            "MAX(records.timestamp) AS end_timestamp",
            "SUM(records.value) AS total"
          )
          .group(:metric_id)
          .order(:metric_id)

        grouped_records = grouped_records.where(metric_id:) if metric_id.present?
        average = grouped_records.index_by(&:metric_id).transform_values { |record| calculate_average(record) }

        Success(result: { average: })
      end

      private

      def calculate_average(record)
        truncated_start = truncate_timestamp(record.start_timestamp)
        truncated_end = truncate_timestamp(record.end_timestamp)

        quantity = (truncated_end - truncated_start) / 1.send(group_by)
        record.total / (quantity.floor + 1)
      end

      def truncate_timestamp(timestamp)
        timestamp.send("beginning_of_#{group_by}")
      end
    end
  end
end
