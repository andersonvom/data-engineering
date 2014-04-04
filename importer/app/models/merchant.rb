class Merchant < ActiveRecord::Base
  has_many :locations, class_name: 'MerchantLocation'
end
