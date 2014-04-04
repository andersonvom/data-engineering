require 'csv'
require 'securerandom'


class Import < ActiveRecord::Base
  has_many :import_items

  validates :file_name, presence: true
  validates :name, presence: true

  def file
    File.open(file_path) if file_path
  end

  def file=(file)
    self.file_name = SecureRandom.uuid + '.tab'
    self.name = file.original_filename or file_name
    store_file(file)
  end

  def each_row(&block)
    CSV.foreach(file_path, headers: true, col_sep: "\t") do |row|
      yield to_attributes(row.to_hash)
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

  def store_file(file)
    File.open(file_path, 'wb') do |f|
      f.write(file.read)
    end
  end

end
