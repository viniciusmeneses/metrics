require "rails_helper"

RSpec.describe "Metrics management" do
  describe "POST /metrics" do
    it "calls Metrics::Create service" do
      allow(Metrics::Create).to receive(:call).and_call_original

      post "/metrics", params: { metric: { name: "Metric" } }, as: :json

      expect(Metrics::Create).to have_received(:call).with("name" => "Metric")
    end

    context "when params are valid" do
      it "responds with metric and status code 201" do
        post "/metrics", params: { metric: { name: "Metric" } }
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(body).to eq(Metric.last.as_json)
      end
    end

    context "when params are invalid" do
      it "responds with errors and status code 422" do
        post "/metrics", params: { metric: { name: "" } }, as: :json
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(body).to include("errors" => { "name" => ["can't be blank"] })
      end
    end
  end
end
