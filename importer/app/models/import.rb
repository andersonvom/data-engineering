class Import < ActiveRecord::Base

  validates :file_path, presence: true

  def file
    File.open(file_path)
  end

  def file=(file)
    self.file_path = file.path
  end

end
