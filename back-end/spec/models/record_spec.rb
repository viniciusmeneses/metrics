require "rails_helper"

RSpec.describe Record do
  describe "#timestamp" do
    it { is_expected.to validate_presence_of(:timestamp) }

    context "when timestamp is future" do
      it "is valid" do
        record = build(:record)
        expect(record).to be_valid
      end
    end

    context "when timestamp is not future" do
      it "is invalid" do
        record = build(:record, timestamp: Date.tomorrow)
        expect(record).to be_invalid
      end
    end
  end

  describe "#value" do
    it { is_expected.to validate_numericality_of(:value).is_greater_than(0) }
  end

  describe "#metric" do
    it { is_expected.to belong_to(:metric) }
  end
end
