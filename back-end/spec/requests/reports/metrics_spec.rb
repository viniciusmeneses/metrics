require "rails_helper"

RSpec.describe "Metrics reports" do
  describe "GET /reports/metrics" do
    let(:metrics) { create_list(:metric, 2) }

    before do
      create(:record, value: 45, timestamp: Time.zone.parse("2023-01-15 20:41:55"), metric: metrics[0])
      create(:record, value: 5, timestamp: Time.zone.parse("2023-01-11 15:22:22"), metric: metrics[0])

      create(:record, value: 10, timestamp: Time.zone.parse("2023-01-04 06:12:34"), metric: metrics[1])
      create(:record, value: 20, timestamp: Time.zone.parse("2023-01-04 12:00:00"), metric: metrics[1])

      allow(Reports::Metrics::AllQuery).to receive(:call).and_call_original
    end

    it "calls Reports::Metrics::AllQuery query" do
      get "/reports/metrics"

      expect(Reports::Metrics::AllQuery).to have_received(:call).with(group_by: nil)
    end

    context "when params are valid" do
      it "responds with metrics and status code 200" do
        get "/reports/metrics", params: { group_by: "day" }

        expect(response).to have_http_status(:ok)
        expect(body).to eq([
          { **metrics[1].as_json, "average" => 30, "series" => [["2023-01-04T00:00:00Z", 30]] },
          { **metrics[0].as_json, "average" => 10, "series" => [["2023-01-11T00:00:00Z", 5], ["2023-01-15T00:00:00Z", 45]] }
        ])
      end
    end

    context "when params are invalid" do
      it "responds with errors and status code 422" do
        get "/reports/metrics", params: { group_by: "second" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(body).to eq("errors" => { "group_by" => ["is not included in the list"] })
      end
    end
  end

  describe "GET /reports/metrics/:id" do
    let(:metric) { create(:metric) }

    before do
      create(:record, value: 100, timestamp: Time.zone.parse("2023-01-15 20:41:55"), metric:)
      create(:record, value: 200, timestamp: Time.zone.parse("2023-01-11 15:22:22"), metric:)

      allow(Reports::Metrics::SingleQuery).to receive(:call).and_call_original
    end

    it "calls Reports::Metrics::SingleQuery query" do
      get "/reports/metrics/#{metric.id}"

      expect(Reports::Metrics::SingleQuery).to have_received(:call).with(id: metric.id, group_by: nil)
    end

    context "when params are valid" do
      it "responds with metric and status code 200" do
        get "/reports/metrics/#{metric.id}", params: { group_by: "day" }

        expect(response).to have_http_status(:ok)
        expect(body).to eq(
          **metric.as_json,
          "average" => 60,
          "series" => [["2023-01-11T00:00:00Z", 200], ["2023-01-15T00:00:00Z", 100]]
        )
      end
    end

    context "when params are invalid" do
      it "responds with errors and status code 422" do
        get "/reports/metrics/0", params: { group_by: "second" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(body).to eq("errors" => { "id" => ["is invalid"] })
      end
    end
  end
end
