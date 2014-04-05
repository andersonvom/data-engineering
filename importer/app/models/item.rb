class Item < ActiveRecord::Base
  belongs_to :merchant
  has_many :inventory_items
  has_many :merchant_locations, through: :inventory_items
end
