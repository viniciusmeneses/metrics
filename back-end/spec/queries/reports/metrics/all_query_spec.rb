require "rails_helper"

RSpec.describe Reports::Metrics::AllQuery do
  describe "#call" do
    describe "failure" do
      let(:failure_result) { result_double(success: false, errors: { attribute: ["message"] }) }

      before { create(:metric) }

      context "when series query fails" do
        it "returns validation errors" do
          allow(Reports::Records::SeriesByMetricQuery).to receive(:call).and_return(failure_result)

          result = described_class.call

          expect(result).to be_a_failure
          expect(result[:errors][:attribute]).to eq(["message"])
        end
      end

      context "when average query fails" do
        it "returns validation errors" do
          allow(Reports::Records::AverageByMetricQuery).to receive(:call).and_return(failure_result)

          result = described_class.call

          expect(result).to be_a_failure
          expect(result[:errors][:attribute]).to eq(["message"])
        end
      end
    end

    describe "success" do
      let(:metrics) { create_list(:metric, 2) }
      let(:average) { result_double(average: { metrics[0].id => 10, metrics[1].id => 20 }) }
      let(:series) do
        result_double(series: {
          metrics[0].id => [[Time.current.iso8601, 100]],
          metrics[1].id => [[Time.current.iso8601, 200]]
        })
      end

      before do
        allow(Reports::Records::AverageByMetricQuery).to receive(:call).and_return(average)
        allow(Reports::Records::SeriesByMetricQuery).to receive(:call).and_return(series)
      end

      it "returns metrics with series and average" do
        result = described_class.call

        expect(result).to be_a_success
        expect(result[:metrics]).to contain_exactly(
          { **metrics[0].as_json, average: 10, series: series[:series][metrics[0].id] },
          { **metrics[1].as_json, average: 20, series: series[:series][metrics[1].id] }
        )
      end

      it "calls series query with group_by attribute" do
        described_class.call(group_by: :hour)

        expect(Reports::Records::SeriesByMetricQuery).to have_received(:call).with(group_by: :hour)
      end

      it "calls average query with per attribute" do
        described_class.call(group_by: :minute)

        expect(Reports::Records::AverageByMetricQuery).to have_received(:call).with(per: :minute)
      end
    end
  end
end
