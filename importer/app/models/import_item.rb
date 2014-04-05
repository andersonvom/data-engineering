require 'csv'


class ImportItem < ActiveRecord::Base
  belongs_to :import

  attr_accessor :purchaser_name, :item_description, :item_price,
                :purchase_count, :merchant_address, :merchant_name

  def self.import(attrs)
    import_item = self.new(attrs)
    if import_item.imported?
      logger.info("\tSkipping line #{import_item.line_number}. Already imported.")
    else
      logger.debug("\tNormalizing line #{import_item.line_number}")
      import_item.normalize!
    end
  end

  def imported?
    obj = self.class.find_by(import: import, line_number: line_number)
    obj and obj.data == nil
  end

  def normalize!
    begin
      import_info!
    rescue => exc
      logger.error("\tFailed to normalize line #{line_number}: #{exc.message}")
      save_data_for_logs!
    end
  end

  private

  def import_info!
    self.transaction do
      purchaser = Purchaser.find_or_create_by(name: purchaser_name)
      merchant = Merchant.find_or_create_by(name: merchant_name)
      location = merchant.locations.find_or_create_by(address: merchant_address)
      item = merchant.items.find_or_create_by(description: item_description)
      inventory_item = location.create_or_update_inventory_item(item, item_price)
      Purchase.create(import: import,
                      purchaser: purchaser,
                      inventory_item: inventory_item,
                      count: purchase_count)
      save
    end
  end

  def save_data_for_logs!
    self.data = all_attrs.to_csv
    save
  end

  def all_attrs
    [purchaser_name, item_description, item_price,
     purchase_count, merchant_address, merchant_name]
  end
end
