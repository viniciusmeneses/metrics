require "rails_helper"

RSpec.describe Reports::Metrics::SingleQuery do
  describe "#call" do
    describe "failure" do
      context "when id is not integer" do
        it "returns a failure" do
          result = described_class.call(id: nil)

          expect(result).to be_a_failure
          expect(result[:errors][:id]).to eq(["must be a kind of Integer"])
        end
      end

      context "when metric does not exist" do
        it "returns a failure" do
          result = described_class.call(id: 5)

          expect(result).to be_a_failure
          expect(result[:errors][:id]).to eq(["is invalid"])
        end
      end

      context "when series query fails" do
        it "returns a failure" do
          metric = create(:metric)
          series = instance_double(Micro::Case::Result, failure?: true, "[]": { attribute: ["message"] })
          allow(Reports::Records::SeriesByMetricQuery).to receive(:call).and_return(series)

          result = described_class.call(id: metric.id)

          expect(result).to be_a_failure
          expect(result[:errors][:attribute]).to eq(["message"])
        end
      end

      context "when average query fails" do
        it "returns a failure" do
          metric = create(:metric)
          average = instance_double(Micro::Case::Result, failure?: true, "[]": { attribute: ["message"] })
          allow(Reports::Records::AverageByMetricQuery).to receive(:call).and_return(average)

          result = described_class.call(id: metric.id)

          expect(result).to be_a_failure
          expect(result[:errors][:attribute]).to eq(["message"])
        end
      end
    end

    describe "success" do
      it "returns metric with series and average" do
        metric = create(:metric)
        series = instance_double(Micro::Case::Result, failure?: false, "[]": { metric.id => [[Time.current.iso8601, 100]] })
        average = instance_double(Micro::Case::Result, failure?: false, "[]": { metric.id => 10 })
        allow(Reports::Records::SeriesByMetricQuery).to receive(:call).and_return(series)
        allow(Reports::Records::AverageByMetricQuery).to receive(:call).and_return(average)

        result = described_class.call(id: metric.id)

        expect(result).to be_a_success
        expect(result[:metric]).to match(
          **metric.as_json,
          average: 10,
          series: series[:series][metric.id]
        )
      end

      it "calls series query with metric_id and group_by" do
        metric = create(:metric)
        series = instance_double(Micro::Case::Result, failure?: false, "[]": {})
        allow(Reports::Records::SeriesByMetricQuery).to receive(:call).and_return(series)

        described_class.call(id: metric.id, group_by: :hour)

        expect(Reports::Records::SeriesByMetricQuery).to have_received(:call).with(
          metric_id: metric.id,
          group_by: :hour
        )
      end

      it "calls average query with metric_id and per" do
        metric = create(:metric)
        average = instance_double(Micro::Case::Result, failure?: false, "[]": {})
        allow(Reports::Records::AverageByMetricQuery).to receive(:call).and_return(average)

        described_class.call(id: metric.id, group_by: :minute)

        expect(Reports::Records::AverageByMetricQuery).to have_received(:call).with(
          metric_id: metric.id,
          per: :minute
        )
      end
    end
  end
end
