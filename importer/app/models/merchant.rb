class Merchant < ActiveRecord::Base
  has_many :locations, class_name: 'MerchantLocation'
  has_many :items
end
