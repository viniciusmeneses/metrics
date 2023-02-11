require "rails_helper"

RSpec.describe Reports::Metrics::SingleQuery do
  describe "#call" do
    let(:metric) { create(:metric) }

    describe "failure" do
      let(:failure_result) { result_double(success: false, errors: { attribute: ["message"] }) }

      context "when id is not integer" do
        it "returns validation errors" do
          result = described_class.call(id: nil)

          expect(result).to be_a_failure
          expect(result[:errors].messages).to eq(id: ["must be a kind of Integer"])
        end
      end

      context "when metric does not exist" do
        it "returns validation errors" do
          result = described_class.call(id: 5)

          expect(result).to be_a_failure
          expect(result[:errors].messages).to eq(id: ["is invalid"])
        end
      end

      context "when series query fails" do
        it "returns validation errors" do
          allow(Reports::Records::SeriesByMetricQuery).to receive(:call).and_return(failure_result)

          result = described_class.call(id: metric.id)

          expect(result).to be_a_failure
          expect(result[:errors][:attribute]).to eq(["message"])
        end
      end

      context "when average query fails" do
        it "returns validation errors" do
          allow(Reports::Records::AverageByMetricQuery).to receive(:call).and_return(failure_result)

          result = described_class.call(id: metric.id)

          expect(result).to be_a_failure
          expect(result[:errors][:attribute]).to eq(["message"])
        end
      end
    end

    describe "success" do
      let(:average) { result_double(average: { metric.id => 10 }) }
      let(:series) { result_double(series: { metric.id => [[Time.current.iso8601, 100]] }) }

      before do
        allow(Reports::Records::AverageByMetricQuery).to receive(:call).and_return(average)
        allow(Reports::Records::SeriesByMetricQuery).to receive(:call).and_return(series)
      end

      it "returns metric with series and average" do
        result = described_class.call(id: metric.id)

        expect(result).to be_a_success
        expect(result[:metric]).to eq(
          **metric.as_json,
          average: 10,
          series: series[:series][metric.id]
        )
      end

      it "calls series query with metric_id and group_by" do
        described_class.call(id: metric.id, group_by: :hour)

        expect(Reports::Records::SeriesByMetricQuery).to have_received(:call).with(
          metric_id: metric.id,
          group_by: :hour
        )
      end

      it "calls average query with metric_id and group_by" do
        described_class.call(id: metric.id, group_by: :minute)

        expect(Reports::Records::AverageByMetricQuery).to have_received(:call).with(
          metric_id: metric.id,
          group_by: :minute
        )
      end
    end
  end
end
