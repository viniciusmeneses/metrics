require "rails_helper"

RSpec.describe "Metrics records management" do
  describe "POST /metrics/:id/records" do
    it "calls Records::Create service" do
      allow(Records::Create).to receive(:call).and_call_original
      params = { timestamp: Time.current.iso8601, value: 25.1 }

      post "/metrics/1/records", params:, as: :json

      expect(Records::Create).to have_received(:call).with(
        "metric_id" => 1,
        "timestamp" => params[:timestamp],
        "value" => params[:value]
      )
    end

    context "when params are valid" do
      it "responds with record and status code 201" do
        metric = create(:metric)
        params = { timestamp: Time.current.iso8601, value: 100 }

        post "/metrics/#{metric.id}/records", params:, as: :json
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(body).to eq(Record.last.as_json)
      end
    end

    context "when params are invalid" do
      it "responds with errors and status code 422" do
        params = { timestamp: "", value: 0 }

        post "/metrics/1/records", params:, as: :json
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(body).to include("errors" => {
          "metric" => ["must exist"],
          "timestamp" => ["can't be blank"],
          "value" => ["must be greater than 0"]
        })
      end
    end
  end
end
