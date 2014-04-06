require 'spec_helper'

describe Import do

  before :each do
    @import = Import.new
    @file = double('file')
    @file.stub(:original_filename).and_return('foo')
  end

  describe "#gross_revenue" do
    it "should sum all prices and counts" do
      @import.purchases.should_receive(:sum)
                     .with('price_in_cents * count')
                     .and_return(1000)
      @import.gross_revenue.should == 10.0
    end
  end

  describe "#progress" do
    it "should return an array of successful and failed import items" do
      successful_items = [1,2,3]
      failed_items = [1]
      @import.import_items.should_receive(:successful).and_return(successful_items)
      @import.import_items.should_receive(:failed).and_return(failed_items)
      @import.progress.should =={success: 3, error: 1}
    end
  end

  describe "#file=" do
    before :each do
      @import.file = @file
    end

    it "should set the name along with the file attribute" do
      @import.name.should == 'foo'
    end

    it "should set the file path along with the file attribute" do
      @import.file_name.include?('.tab').should == true
    end

    it "should keep a reference to the file in memory" do
      @import.temp_file.should == @file
    end
  end

  describe "#file" do
    it "should be nil if no file has been set" do
      @import.file.should be_nil
    end

    it "should read the store file" do
      @import.stub(:file_path).and_return('/path/to/file')
      File.should_receive(:open).with('/path/to/file')

      @import.file
    end
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
