class Batch < ApplicationRecord
  validates :name, :description, presence: true

  belongs_to :batch
end
