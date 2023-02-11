require "rails_helper"

RSpec.describe Reports::Records::SeriesByMetricQuery do
  describe "#call" do
    describe "failure" do
      context "when metric_id is not integer" do
        it "returns validation errors" do
          result = described_class.call(metric_id: "1")

          expect(result).to be_a_failure
          expect(result[:errors].messages).to eq(metric_id: ["must be a kind of Integer"])
        end
      end

      context "when group_by is not symbol" do
        it "returns validation errors" do
          result = described_class.call(group_by: "year")

          expect(result).to be_a_failure
          expect(result[:errors].messages).to eq(group_by: ["must be a kind of Symbol", "is not included in the list"])
        end
      end

      context "when group_by is not minute, hour or day" do
        it "returns validation errors" do
          result = described_class.call(group_by: :year)

          expect(result).to be_a_failure
          expect(result[:errors].messages).to eq(group_by: ["is not included in the list"])
        end
      end
    end

    describe "success" do
      let(:metrics) { create_list(:metric, 2) }

      it "returns series by metric" do
        create_list(:record, 5, metric: metrics[0])
        create_list(:record, 5, metric: metrics[1])

        result = described_class.call(group_by: :day)

        expect(result).to be_a_success
        expect(result[:series]).to include(
          metrics[0].id => [[satisfy(&:to_time), be_a(Numeric)]],
          metrics[1].id => [[satisfy(&:to_time), be_a(Numeric)]]
        )
      end

      context "when group_by minute" do
        it "returns grouped series" do
          metric = metrics[0]
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 01:05:30"), metric:)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 01:06:55"), metric:)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 01:05:10"), metric:)

          result = described_class.call(group_by: :minute)

          expect(result).to be_a_success
          expect(result[:series]).to eq(metric.id => [
            ["2023-01-01T01:05:00Z", 200],
            ["2023-01-01T01:06:00Z", 100]
          ])
        end
      end

      context "when group_by hour" do
        it "returns grouped series" do
          metric = metrics[0]
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 05:05:30"), metric:)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 20:10:55"), metric:)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 20:50:10"), metric:)

          result = described_class.call(group_by: :hour)

          expect(result).to be_a_success
          expect(result[:series]).to eq(metric.id => [
            ["2023-01-01T05:00:00Z", 100],
            ["2023-01-01T20:00:00Z", 200]
          ])
        end
      end

      context "when group_by day" do
        it "returns grouped series" do
          metric = metrics[0]
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 05:05:30"), metric:)
          create(:record, value: 100, timestamp: Time.zone.parse("2022-05-01 20:41:55"), metric:)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 15:22:22"), metric:)

          result = described_class.call(group_by: :day)

          expect(result).to be_a_success
          expect(result[:series]).to eq(metric.id => [
            ["2022-05-01T00:00:00Z", 100],
            ["2023-01-01T00:00:00Z", 200]
          ])
        end
      end

      context "when metric_id is present" do
        it "returns only series for metric" do
          create_list(:record, 5, metric: metrics[0])
          create_list(:record, 5, metric: metrics[1])

          result = described_class.call(metric_id: metrics[0].id, group_by: :minute)

          expect(result).to be_a_success
          expect(result[:series]).to include(metrics[0].id => [[satisfy(&:to_time), be_a(Numeric)]])
        end
      end
    end
  end
end
