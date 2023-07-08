class Address < ApplicationRecord
  validates :location, :city, :state, :pincode, presence: true

  belongs_to :addressable, polymorphic: true

  def full_address
    address = [location, city, state, pincode]
    address.reject(&:blank?).join(",").humanize
  end
end
