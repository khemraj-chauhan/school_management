class School < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_one :address, as: :addressable, dependent: :destroy

  has_many :school_admins, dependent: :destroy
  has_many :admins, through: :school_admins

  accepts_nested_attributes_for :address
end
