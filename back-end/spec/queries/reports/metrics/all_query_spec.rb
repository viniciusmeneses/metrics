require "rails_helper"

RSpec.describe Reports::Metrics::AllQuery do
  describe "#call" do
    describe "failure" do
      context "when series query fails" do
        it "returns a failure" do
          series = instance_double(Micro::Case::Result, failure?: true, "[]": { attribute: ["message"] })
          allow(Reports::Records::SeriesByMetricQuery).to receive(:call).and_return(series)

          result = described_class.call

          expect(result).to be_a_failure
          expect(result[:errors][:attribute]).to eq(["message"])
        end
      end

      context "when average query fails" do
        it "returns a failure" do
          average = instance_double(Micro::Case::Result, failure?: true, "[]": { attribute: ["message"] })
          allow(Reports::Records::AverageByMetricQuery).to receive(:call).and_return(average)

          result = described_class.call

          expect(result).to be_a_failure
          expect(result[:errors][:attribute]).to eq(["message"])
        end
      end
    end

    describe "success" do
      it "returns metrics with series and average" do
        metric_1 = create(:metric)
        metric_2 = create(:metric)
        series = instance_double(Micro::Case::Result, failure?: false, "[]": {
          metric_1.id => [[Time.current.iso8601, 100]],
          metric_2.id => [[Time.current.iso8601, 200]]
        })
        average = instance_double(Micro::Case::Result, failure?: false, "[]": { metric_1.id => 10, metric_2.id => 20 })
        allow(Reports::Records::SeriesByMetricQuery).to receive(:call).and_return(series)
        allow(Reports::Records::AverageByMetricQuery).to receive(:call).and_return(average)

        result = described_class.call

        expect(result).to be_a_success
        expect(result[:metrics]).to contain_exactly(
          { **metric_1.as_json, average: 10, series: series[:series][metric_1.id] },
          { **metric_2.as_json, average: 20, series: series[:series][metric_2.id] }
        )
      end

      it "calls series query with group_by attribute" do
        series = instance_double(Micro::Case::Result, failure?: false, "[]": nil)
        allow(Reports::Records::SeriesByMetricQuery).to receive(:call).and_return(series)

        described_class.call(group_by: :hour)

        expect(Reports::Records::SeriesByMetricQuery).to have_received(:call).with(group_by: :hour)
      end

      it "calls average query with per attribute" do
        average = instance_double(Micro::Case::Result, failure?: false, "[]": nil)
        allow(Reports::Records::AverageByMetricQuery).to receive(:call).and_return(average)

        described_class.call(group_by: :minute)

        expect(Reports::Records::AverageByMetricQuery).to have_received(:call).with(per: :minute)
      end
    end
  end
end
