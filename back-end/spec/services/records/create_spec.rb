require "rails_helper"

RSpec.describe Records::Create do
  describe "#call" do
    describe "failure" do
      context "when timestamp is not string" do
        it "returns validation errors" do
          result = described_class.call(timestamp: 1, value: 10, metric_id: 1)

          expect(result).to be_a_failure
          expect(result[:errors].messages).to eq(timestamp: ["must be a kind of String"])
        end
      end

      context "when value is not number" do
        it "returns validation errors" do
          result = described_class.call(value: "100", timestamp: Time.current.iso8601, metric_id: 1)

          expect(result).to be_a_failure
          expect(result[:errors].messages).to eq(value: ["must be a kind of Numeric"])
        end
      end

      context "when metric_id is not integer" do
        it "returns validation errors" do
          result = described_class.call(metric_id: 3.5, timestamp: Time.current.iso8601, value: 100)

          expect(result).to be_a_failure
          expect(result[:errors].messages).to eq(metric_id: ["must be a kind of Integer"])
        end
      end

      context "when record is invalid" do
        it "returns validation errors" do
          result = described_class.call(timestamp: "---", value: 0, metric_id: 20)

          expect(result).to be_a_failure
          expect(result[:errors].messages).to eq(
            metric: ["must exist"],
            timestamp: ["can't be blank"],
            value: ["must be greater than 0"]
          )
        end
      end
    end

    describe "success" do
      let(:metric) { create(:metric) }
      let(:timestamp) { Time.current.iso8601 }

      it "creates a record" do
        result = described_class.call(timestamp:, value: 100, metric_id: metric.id)

        expect(result).to be_a_success
        expect(result[:record]).to be_persisted.and(have_attributes(
          timestamp: timestamp.to_time,
          value: 100,
          metric_id: metric.id
        ))
      end
    end
  end
end
