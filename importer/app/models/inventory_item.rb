class InventoryItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :merchant_location
  has_many :merchants, -> { distinct }, through: :merchant_location

  def price
    price_in_cents.to_d / 100
  end

  def price=(value)
    self.price_in_cents = (value.to_d * 100).round
  end
end
