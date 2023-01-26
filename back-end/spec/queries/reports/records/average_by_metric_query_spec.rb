require "rails_helper"

RSpec.describe Reports::Records::AverageByMetricQuery do
  describe "#call" do
    describe "failure" do
      context "when metric_id is not integer" do
        it "returns a failure" do
          result = described_class.call(metric_id: "1")

          expect(result).to be_a_failure
          expect(result[:errors][:metric_id]).to eq(["must be a kind of Integer"])
        end
      end

      context "when per is not symbol" do
        it "returns a failure" do
          result = described_class.call(per: "year")

          expect(result).to be_a_failure
          expect(result[:errors][:per]).to include("must be a kind of Symbol")
        end
      end

      context "when per is not minute, hour or day" do
        it "returns a failure" do
          result = described_class.call(per: :year)

          expect(result).to be_a_failure
          expect(result[:errors][:per]).to eq(["is not included in the list"])
        end
      end
    end

    describe "success" do
      it "calculates average by metric" do
        metric_1 = create(:metric)
        metric_2 = create(:metric)
        create_list(:record, 5, metric: metric_1)
        create_list(:record, 5, metric: metric_2)

        result = described_class.call(per: :day)

        expect(result).to be_a_success
        expect(result[:average]).to match(metric_1.id => be_a(Numeric), metric_2.id => be_a(Numeric))
      end

      context "when per minute" do
        it "calculates average by metric" do
          metric = create(:metric)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 01:05:30"), metric:)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 01:06:55"), metric:)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 01:05:10"), metric:)

          result = described_class.call(per: :minute)

          expect(result).to be_a_success
          expect(result[:average]).to match(metric.id => 150)
        end
      end

      context "when per hour" do
        it "calculates average by metric" do
          metric = create(:metric)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 05:05:30"), metric:)
          create(:record, value: 200, timestamp: Time.zone.parse("2023-01-01 08:10:55"), metric:)
          create(:record, value: 200, timestamp: Time.zone.parse("2023-01-01 09:50:10"), metric:)

          result = described_class.call(per: :hour)

          expect(result).to be_a_success
          expect(result[:average]).to match(metric.id => 100)
        end
      end

      context "when per day" do
        it "calculates average by metric" do
          metric = create(:metric)
          create(:record, value: 100, timestamp: Time.zone.parse("2023-01-01 05:05:30"), metric:)
          create(:record, value: 45, timestamp: Time.zone.parse("2023-01-15 20:41:55"), metric:)
          create(:record, value: 5, timestamp: Time.zone.parse("2023-01-10 15:22:22"), metric:)

          result = described_class.call(per: :day)

          expect(result).to be_a_success
          expect(result[:average]).to match(metric.id => 10)
        end
      end

      context "when metric_id is present" do
        it "calculates average only for specified metric" do
          metric_1 = create(:metric)
          metric_2 = create(:metric)
          create_list(:record, 5, metric: metric_1)
          create_list(:record, 5, metric: metric_2)

          result = described_class.call(metric_id: metric_1.id, per: :minute)

          expect(result).to be_a_success
          expect(result[:average]).to match(metric_1.id => be_a(Numeric))
        end
      end
    end
  end
end
