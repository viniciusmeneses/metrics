class Metric < ApplicationRecord
  has_many :records, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
end
