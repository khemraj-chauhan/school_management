class Course < ApplicationRecord
  validates :title, :description, presence: true

  belongs_to :school
end
