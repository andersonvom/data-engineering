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

end
