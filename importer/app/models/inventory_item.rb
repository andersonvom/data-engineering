class InventoryItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :merchant_location
  has_many :merchants, -> { distinct }, through: :merchant_location
end
