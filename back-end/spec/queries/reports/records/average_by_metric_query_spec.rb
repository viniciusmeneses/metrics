require "rails_helper"

RSpec.describe Reports::Records::AverageByMetricQuery do
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

      it "calculates average by metric" do
        create_list(:record, 2, metric: metrics[0])
        create_list(:record, 2, metric: metrics[1])
        result = described_class.call(group_by: :day)

        expect(result).to be_a_success
        expect(result[:average]).to include(metrics[0].id => be_a(Numeric), metrics[1].id => be_a(Numeric))
      end

      context "when group_by minute" do
        it "calculates average by metric" do
          metric = metrics[0]
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 01:05:30"), metric:)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 01:06:55"), metric:)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 01:05:10"), metric:)

          result = described_class.call(group_by: :minute)

          expect(result).to be_a_success
          expect(result[:average]).to eq(metric.id => 150)
        end
      end

      context "when group_by hour" do
        it "calculates average by metric" do
          metric = metrics[0]
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 05:05:30"), metric:)
          create(:record, value: 200, timestamp: Time.zone.parse("2023-01-01 08:10:55"), metric:)
          create(:record, value: 200, timestamp: Time.zone.parse("2023-01-01 09:50:10"), metric:)

          result = described_class.call(group_by: :hour)

          expect(result).to be_a_success
          expect(result[:average]).to eq(metric.id => 100)
        end
      end

      context "when group_by day" do
        it "calculates average by metric" do
          metric = metrics[0]
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 05:05:30"), metric:)
          create(:record, value: 45, timestamp: Time.zone.parse("2023-01-15 20:41:55"), metric:)
          create(:record, value: 5, timestamp: Time.zone.parse("2023-01-10 15:22:22"), metric:)

          result = described_class.call(group_by: :day)

          expect(result).to be_a_success
          expect(result[:average]).to eq(metric.id => 10)
        end
      end

      context "when metric_id is present" do
        it "calculates average only for specified metric" do
          create_list(:record, 2, metric: metrics[0])
          create_list(:record, 2, metric: metrics[1])

          result = described_class.call(metric_id: metrics[0].id, group_by: :minute)

          expect(result).to be_a_success
          expect(result[:average]).to include(metrics[0].id => be_a(Numeric))
        end
      end
    end
  end
end
