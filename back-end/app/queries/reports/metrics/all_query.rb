module Reports
  module Metrics
    class AllQuery < Micro::Case
      attribute :group_by

      class InvalidQueryError < StandardError
        attr_reader :errors

        def initialize(errors)
          @errors = errors
        end
      end

      def call!
        series_by_metric = get_series_by_metric
        average_by_metric = get_average_by_metric

        metrics = Metric.all.order(created_at: :desc).map do |metric|
          id = metric.id
          { **metric.as_json, average: average_by_metric[id] || 0, series: series_by_metric[id] || [] }
        end

        Success(result: { metrics: })
      rescue InvalidQueryError => error
        Failure(:invalid_query, result: { errors: error.errors })
      end

      private

      def get_series_by_metric
        result = Reports::Records::SeriesByMetricQuery.call(group_by:)
        raise InvalidQueryError, result[:errors] if result.failure?
        result[:series]
      end

      def get_average_by_metric
        result = Reports::Records::AverageByMetricQuery.call(per: group_by)
        raise InvalidQueryError, result[:errors] if result.failure?
        result[:average]
      end
    end
  end
end
