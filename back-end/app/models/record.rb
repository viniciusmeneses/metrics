class Record < ApplicationRecord
  belongs_to :metric

  validates :timestamp, presence: true
  validates :value, numericality: { greater_than: 0 }

  validate :timestamp_must_not_be_future

  private

  def timestamp_must_not_be_future
    errors.add(:timestamp, :invalid) if timestamp&.future?
  end
end
