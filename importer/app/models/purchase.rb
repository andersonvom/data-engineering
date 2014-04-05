class Purchase < ActiveRecord::Base
  belongs_to :import
  belongs_to :purchaser
  belongs_to :inventory_item
  has_many :items, -> { distinct }, through: :inventory_item

  def price
    price_in_cents.to_d / 100
  end

  def price=(value)
    self.price_in_cents = (value.to_d * 100).round
  end

  def inventory_item=(item)
    super(item)
    self.price = item.price
  end
end
