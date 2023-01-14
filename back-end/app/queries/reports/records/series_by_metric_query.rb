module Reports
  module Records
    class SeriesByMetricQuery < Micro::Case
      attribute :metric_id
      attribute :group_by, default: :day

      validates :metric_id, kind: Integer, allow_nil: true
      validates :group_by, kind: Symbol, inclusion: { in: [:minute, :hour, :day] }

      def call!
        grouped_records = Record
          .select(:metric_id, "#{truncate_timestamp_sql} AS timestamp", "SUM(records.value) AS total")
          .group(:metric_id, truncate_timestamp_sql)
          .order(truncate_timestamp_sql)

        grouped_records = grouped_records.where(metric_id:) if metric_id.present?
        series = grouped_records.group_by(&:metric_id).transform_values { |records| to_series(records) }

        Success(result: { series: })
      end

      private

      def truncate_timestamp_sql
        Arel.sql(Record.sanitize_sql_array([
          "DATE_TRUNC(?, records.timestamp AT TIME ZONE ?)",
          group_by,
          Time.zone.formatted_offset
        ]))
      end

      def to_series(records)
        records.map { |record| [record.timestamp.iso8601, record.total] }
      end
    end
  end
end
