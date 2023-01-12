class MetricsController < ApplicationController
  def create
    create_params = params.require(:metric).permit(:name)

    Metrics::Create.call(**create_params)
      .on_success { |result| render(status: :created, json: result[:metric].as_json) }
      .on_failure { |result| render(status: :unprocessable_entity, json: { errors: result[:errors].messages }) }
  end
end
