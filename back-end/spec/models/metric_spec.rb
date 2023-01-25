require "rails_helper"

RSpec.describe Metric do
  describe "#name" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(30) }
  end

  describe "#records" do
    it { is_expected.to have_many(:records).dependent(:destroy) }
  end
end
