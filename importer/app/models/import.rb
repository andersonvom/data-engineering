require 'csv'
require 'securerandom'


class Import < ActiveRecord::Base
  has_many :import_items
  has_many :purchases

  validates :file_name, presence: true
  validates :name, presence: true

  after_save :store_file
  after_destroy :delete_file

  attr_accessor :temp_file

  def progress
    {
      success: import_items.successful.count,
      error: import_items.failed.count,
    }
  end

  def gross_revenue
    purchases.sum('price_in_cents * count').to_d / 100
  end

  def file
    File.open(file_path) if file_path
  end

  def file=(file)
    self.file_name = SecureRandom.uuid + '.tab'
    self.name = file.original_filename or file_name
    self.temp_file = file
  end

  def each_row(&block)
    CSV.foreach(file_path, headers: true, col_sep: "\t") do |row|
      yield to_attributes(row.to_hash.update('line number' => $.))
    end
  end

  def save_items
    self.each_row do |row|
      row.update(import: self)  # keep memory low with large files
      ImportItem.import(row)
    end

    if progress[:error] == 0
      self.imported = true
      save
    end
  end

  def self.import_files
    self.where(imported: false).each do |import|
      logger.info("Saving items from #{import.name} (#{import.file.path}) to DB")
      import.save_items
    end
  end

  private

  def to_attributes(row_hash)
    attr_hash = {}
    row_hash.each do |key, value|
      attr_hash[key.gsub(' ', '_').to_sym] = value
    end
    return attr_hash
  end

  def file_path
    Rails.root.join('public', 'uploads', file_name) if file_name
  end

  def store_file
    if temp_file
      File.open(file_path, 'wb') do |f|
        f.write(temp_file.read)
      end
    end
  end

  def delete_file
    FileUtils.rm file_path
  end
end
