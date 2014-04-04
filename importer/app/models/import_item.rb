class ImportItem < ActiveRecord::Base
  belongs_to :import

  attr_accessor :purchaser_name, :item_description, :item_price,
                :purchase_count, :merchant_address, :merchant_name

  def self.import(attrs)
    item = self.new(attrs)
    if item.imported?
      logger.info("\tSkipping line #{item.line_number}. Already imported.")
    else
      item.normalize!
    end
  end

  def imported?
    self.class.where(import: import, line_number: line_number).size > 0
  end

  def normalize!
    # TODO: save all models
    logger.debug("\tNormalizing line #{line_number}")
    save
  end
end
