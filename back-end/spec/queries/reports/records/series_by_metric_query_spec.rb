require "rails_helper"

RSpec.describe Reports::Records::SeriesByMetricQuery do
  describe "#call" do
    describe "failure" do
      context "when metric_id is not integer" do
        it "returns a failure" do
          result = described_class.call(metric_id: "1")

          expect(result).to be_a_failure
          expect(result[:errors][:metric_id]).to eq(["must be a kind of Integer"])
        end
      end

      context "when group_by is not symbol" do
        it "returns a failure" do
          result = described_class.call(group_by: "year")

          expect(result).to be_a_failure
          expect(result[:errors][:group_by]).to include("must be a kind of Symbol")
        end
      end

      context "when group_by is not minute, hour or day" do
        it "returns a failure" do
          result = described_class.call(group_by: :year)

          expect(result).to be_a_failure
          expect(result[:errors][:group_by]).to eq(["is not included in the list"])
        end
      end
    end

    describe "success" do
      it "returns series by metric" do
        metric_1 = create(:metric)
        metric_2 = create(:metric)
        create_list(:record, 5, metric: metric_1)
        create_list(:record, 5, metric: metric_2)

        result = described_class.call(group_by: :day)

        expect(result).to be_a_success
        expect(result[:series]).to include(
          metric_1.id => [[satisfy(&:to_time), be_a(Numeric)]],
          metric_2.id => [[satisfy(&:to_time), be_a(Numeric)]]
        )
      end

      context "when group_by minute" do
        it "returns grouped series" do
          metric = create(:metric)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 01:05:30"), metric:)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 01:06:55"), metric:)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 01:05:10"), metric:)

          result = described_class.call(group_by: :minute)

          expect(result).to be_a_success
          expect(result[:series]).to include(metric.id => [
            ["2023-01-01T01:05:00Z", 200],
            ["2023-01-01T01:06:00Z", 100]
          ])
        end
      end

      context "when group_by hour" do
        it "returns grouped series" do
          metric = create(:metric)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 05:05:30"), metric:)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 20:10:55"), metric:)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 20:50:10"), metric:)

          result = described_class.call(group_by: :hour)

          expect(result).to be_a_success
          expect(result[:series]).to include(metric.id => [
            ["2023-01-01T05:00:00Z", 100],
            ["2023-01-01T20:00:00Z", 200]
          ])
        end
      end

      context "when group_by day" do
        it "returns grouped series" do
          metric = create(:metric)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 05:05:30"), metric:)
          create(:record, value: 100, timestamp: Time.zone.parse("2022-05-01 20:41:55"), metric:)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 15:22:22"), metric:)

          result = described_class.call(group_by: :day)

          expect(result).to be_a_success
          expect(result[:series]).to include(metric.id => [
            ["2022-05-01T00:00:00Z", 100],
            ["2023-01-01T00:00:00Z", 200]
          ])
        end
      end

      context "when metric_id is present" do
        it "returns only series for metric" do
          metric_1 = create(:metric)
          metric_2 = create(:metric)
          create_list(:record, 5, metric: metric_1)
          create_list(:record, 5, metric: metric_2)

          result = described_class.call(metric_id: metric_1.id, group_by: :minute)

          expect(result).to be_a_success
          expect(result[:series]).to include(metric_1.id => [[satisfy(&:to_time), be_a(Numeric)]])
        end
      end
    end
  end
end
