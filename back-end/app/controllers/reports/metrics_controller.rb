module Reports
  class MetricsController < ApplicationController
    def index
      Reports::Metrics::AllQuery.call(**search_params)
        .on_success { |result| render(status: :created, json: result[:metrics].as_json) }
        .on_failure { |result| render(status: :unprocessable_entity, json: { errors: result[:errors].messages }) }
    end

    def show
      Reports::Metrics::SingleQuery.call(**search_params, id: params[:id].to_i)
        .on_success { |result| render(status: :created, json: result[:metric].as_json) }
        .on_failure { |result| render(status: :unprocessable_entity, json: { errors: result[:errors].messages }) }
    end

    private

    def search_params
      { group_by: params[:group_by]&.to_sym }
    end
  end
end
