class MerchantLocation < ActiveRecord::Base
  belongs_to :merchant
  has_many :inventory_items
  has_many :items, through: :inventory_items

  def create_or_update_inventory_item(item, price)
    inventory_item = inventory_items.find_or_initialize_by(item: item)
    inventory_item.price = price
    inventory_item.save
    inventory_item
  end
end
