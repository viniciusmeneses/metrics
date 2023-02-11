require "rails_helper"

RSpec.describe "Metrics management" do
  let(:body) { JSON.parse(response.body) }

  describe "POST /metrics" do
    before { allow(Metrics::Create).to receive(:call).and_call_original }

    it "calls Metrics::Create service" do
      post "/metrics", as: :json, params: { metric: { name: "Metric" } }

      expect(Metrics::Create).to have_received(:call).with("name" => "Metric")
    end

    context "when params are valid" do
      it "responds with metric and status code 201" do
        post "/metrics", as: :json, params: { metric: { name: "Metric" } }

        expect(response).to have_http_status(:created)
        expect(body).to eq(Metric.last.as_json)
      end
    end

    context "when params are invalid" do
      it "responds with errors and status code 422" do
        post "/metrics", as: :json, params: { metric: { name: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(body).to include("errors" => { "name" => ["can't be blank"] })
      end
    end
  end
end
