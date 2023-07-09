class Course < ApplicationRecord
  validates :title, :description, presence: true

  belongs_to :school

  has_many :batches, dependent: :destroy
end
