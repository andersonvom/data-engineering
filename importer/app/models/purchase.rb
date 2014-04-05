class Purchase < ActiveRecord::Base
  belongs_to :import
  belongs_to :purchaser
  belongs_to :inventory_item
  has_many :items, -> { distinct }, through: :inventory_item
end
