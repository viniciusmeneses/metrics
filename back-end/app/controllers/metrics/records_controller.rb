module Metrics
  class RecordsController < ApplicationController
    def create
      create_params = params.require(:record).permit(:timestamp, :value)
      create_params[:metric_id] = params[:metric_id].to_i

      Records::Create.call(**create_params)
        .on_success { |result| render(status: :created, json: result[:record].as_json) }
        .on_failure { |result| render(status: :unprocessable_entity, json: { errors: result[:errors].messages }) }
    end
  end
end
