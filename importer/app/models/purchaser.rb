class Purchaser < ActiveRecord::Base
  has_many :purchases
  has_many :items, -> { distinct }, through: :purchases
end
