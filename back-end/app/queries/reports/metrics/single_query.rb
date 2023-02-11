module Reports
  module Metrics
    class SingleQuery < Micro::Case
      attribute :id
      attribute :group_by

      validates :id, kind: Integer

      def call!
        metric = Metric.find(id)

        Success(result: { metric: {
          **metric.as_json,
          average: average_for_metric || 0,
          series: series_for_metric || []
        } })
      rescue ActiveRecord::RecordNotFound
        errors.add(:id, :invalid)
        Failure(:metric_not_found, result: { errors: })
      rescue Errors::InvalidQuery => error
        Failure(:invalid_query, result: { errors: error.errors })
      end

      private

      def series_for_metric
        result = Reports::Records::SeriesByMetricQuery.call(metric_id: id, group_by:)
        raise Errors::InvalidQuery, result[:errors] if result.failure?
        result[:series][id]
      end

      def average_for_metric
        result = Reports::Records::AverageByMetricQuery.call(metric_id: id, per: group_by)
        raise Errors::InvalidQuery, result[:errors] if result.failure?
        result[:average][id]
      end
    end
  end
end
