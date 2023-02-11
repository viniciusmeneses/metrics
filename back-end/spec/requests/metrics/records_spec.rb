require "rails_helper"

RSpec.describe "Metrics records management" do
  let(:metric) { create(:metric) }

  describe "POST /metrics/:id/records" do
    before { allow(Records::Create).to receive(:call).and_call_original }

    it "calls Records::Create service" do
      params = { timestamp: Time.current.iso8601, value: 25.1 }

      post "/metrics/#{metric.id}/records", as: :json, params: params

      expect(Records::Create).to have_received(:call).with(
        "metric_id" => metric.id,
        "timestamp" => params[:timestamp],
        "value" => params[:value]
      )
    end

    context "when params are valid" do
      it "responds with record and status code 201" do
        post "/metrics/#{metric.id}/records", as: :json, params: { timestamp: Time.current.iso8601, value: 100 }
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(body).to eq(Record.last.as_json)
      end
    end

    context "when params are invalid" do
      it "responds with errors and status code 422" do
        post "/metrics/1/records", as: :json, params: { timestamp: "", value: 0 }
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(body).to eq("errors" => {
          "metric" => ["must exist"],
          "timestamp" => ["can't be blank"],
          "value" => ["must be greater than 0"]
        })
      end
    end
  end
end
