module Reports
  module Metrics
    class SingleQuery < Micro::Case
      attribute :id
      attribute :group_by

      validates :id, kind: Integer

      class InvalidQueryError < StandardError
        attr_reader :errors

        def initialize(errors)
          @errors = errors
        end
      end

      def call!
        metric = Metric.find(id)
        series = get_series_for(metric)
        average = get_average_for(metric)

        Success(result: { metric: { **metric.as_json, average:, series: } })
      rescue ActiveRecord::RecordNotFound
        errors.add(:id, :invalid)
        Failure(:metric_not_found, result: { errors: })
      rescue InvalidQueryError => error
        Failure(:invalid_query, result: { errors: error.errors })
      end

      private

      def get_series_for(metric_id)
        result = Reports::Records::SeriesByMetricQuery.call(metric_id:, group_by:)
        raise InvalidQueryError, result[:errors] if result.failure?
        result[:series][metric_id]
      end

      def get_average_for(metric_id)
        result = Reports::Records::AverageByMetricQuery.call(metric_id:, per: group_by)
        raise InvalidQueryError, result[:errors] if result.failure?
        result[:average][metric_id]
      end
    end
  end
end
