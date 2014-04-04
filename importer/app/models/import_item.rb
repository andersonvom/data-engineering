class ImportItem < ActiveRecord::Base
  belongs_to :import

  def self.import(attrs)
  end

end
