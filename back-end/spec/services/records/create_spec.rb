require "rails_helper"

RSpec.describe Records::Create do
  describe "#call" do
    describe "failure" do
      context "with invalid attributes" do
        context "when timestamp is not string" do
          it "returns a failure" do
            result = described_class.call(timestamp: 1)

            expect(result).to be_a_failure
            expect(result[:errors][:timestamp]).to eq(["must be a kind of String"])
          end
        end

        context "when value is not number" do
          it "returns a failure" do
            result = described_class.call(value: "100")

            expect(result).to be_a_failure
            expect(result[:errors][:value]).to eq(["must be a kind of Numeric"])
          end
        end

        context "when metric_id is not integer" do
          it "returns a failure" do
            result = described_class.call(metric_id: 3.5)

            expect(result).to be_a_failure
            expect(result[:errors][:metric_id]).to eq(["must be a kind of Integer"])
          end
        end
      end

      context "when record is invalid" do
        it "returns a failure" do
          result = described_class.call(timestamp: "---", value: 0, metric_id: 20)

          expect(result).to be_a_failure
          expect(result.type).to eq(:invalid_record)
          expect(result[:errors]).to be_a(ActiveModel::Errors)
        end
      end
    end

    describe "success" do
      it "creates a record" do
        metric = create(:metric)
        timestamp = Time.current.iso8601

        result = described_class.call(timestamp:, value: 100, metric_id: metric.id)

        expect(result).to be_a_success
        expect(result[:record]).to be_persisted
        expect(result[:record]).to have_attributes(
          timestamp: timestamp.to_time,
          value: 100,
          metric_id: metric.id
        )
      end
    end
  end
end
