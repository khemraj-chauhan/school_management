class Batch < ApplicationRecord
  validates :name, :description, presence: true

  belongs_to :course

  has_many :student_batches, dependent: :destroy
  has_many :students, through: :student_batches
end
