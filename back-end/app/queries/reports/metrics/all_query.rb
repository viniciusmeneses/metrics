module Reports
  module Metrics
    class AllQuery < Micro::Case
      attribute :group_by

      def call!
        metrics = Metric.all.order(created_at: :desc).map do |metric|
          id = metric.id
          { **metric.as_json, average: average_by_metric[id] || 0, series: series_by_metric[id] || [] }
        end

        Success(result: { metrics: })
      rescue Errors::InvalidQuery => error
        Failure(:invalid_query, result: { errors: error.errors })
      end

      private

      def series_by_metric
        @series_by_metric ||= begin
          result = Reports::Records::SeriesByMetricQuery.call(group_by:)
          raise Errors::InvalidQuery, result[:errors] if result.failure?
          result[:series]
        end
      end

      def average_by_metric
        @average_by_metric ||= begin
          result = Reports::Records::AverageByMetricQuery.call(per: group_by)
          raise Errors::InvalidQuery, result[:errors] if result.failure?
          result[:average]
        end
      end
    end
  end
end
