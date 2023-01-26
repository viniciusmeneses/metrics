require "rails_helper"

RSpec.describe Metrics::Create do
  describe "#call" do
    describe "failure" do
      context "when name is not string" do
        it "returns a failure" do
          result = described_class.call(name: 1)

          expect(result).to be_a_failure
          expect(result[:errors][:name]).to eq(["must be a kind of String"])
        end
      end

      context "when metric is invalid" do
        it "returns a failure" do
          result = described_class.call(name: "")

          expect(result).to be_a_failure
          expect(result.type).to eq(:invalid_metric)
          expect(result[:errors]).to be_a(ActiveModel::Errors)
        end
      end
    end

    describe "success" do
      it "creates a metric" do
        result = described_class.call(name: "Metric")

        expect(result).to be_a_success
        expect(result[:metric]).to be_persisted
        expect(result[:metric]).to have_attributes(name: "Metric")
      end
    end
  end
end
