require 'spec_helper'

describe Import do

  before :each do
    @import = Import.new
    @file = double('file')
    @file.stub(:original_filename).and_return('foo')
  end

  it "should have a file attribute" do
    expect(@import.file).to be_nil
  end

  it "should set the name along with the file attribute" do
    @file.should_receive(:read)
    @import.file = @file
    expect(@import.name).to eq('foo')
  end

  it "should set the file path along with the file attribute" do
    @file.should_receive(:read)
    @import.file = @file
    @import.file_name.include?('.tab').should == true
  end

  it "should store the file in the disk" do
    @import.stub(:file_path).and_return('/path/to/file')
    File.should_receive(:open).with('/path/to/file', 'wb')

    @import.file = @file
  end

  it "should get the store file" do
    @import.stub(:file_path).and_return('/path/to/file')
    File.should_receive(:open).with('/path/to/file')

    @import.file
  end

  it "should yield TAB rows as attribute hashes" do
    fixture_file = Rails.root.join('spec', 'fixtures', 'example_input.tab')
    @import.stub(:file_path).and_return(fixture_file)
    @import.each_row do |row|
      row.include?(:purchaser_name).should be_true
    end
  end

  it "should save all items from TAB file" do
    @import.stub(:file_path).and_return(Rails.root.join('..', 'example_input.tab'))
    ImportItem.should_receive(:import).exactly(4).times
    @import.save_items
    @import.imported.should be_true
  end

  it "should import all files" do
    Import.should_receive(:where).with(imported: false).and_return([@import])
    @import.should_receive(:save_items)
    file = double('file')
    file.should_receive(:path)
    @import.stub(:file).and_return(file)
    Import.import_files
  end

end
