require 'securerandom'


class Import < ActiveRecord::Base

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

  private

  def file_path
    Rails.root.join('public', 'uploads', file_name) if file_name
  end

  def store_file(file)
    File.open(file_path, 'wb') do |f|
      f.write(file.read)
    end
  end

end
