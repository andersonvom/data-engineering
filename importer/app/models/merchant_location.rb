class MerchantLocation < ActiveRecord::Base
  belongs_to :merchant
  has_many :inventory_items
  has_many :items, through: :inventory_items
end
