require 'spec_helper'

describe ImportItem do

  before :each do
    @item = ImportItem.new
  end

  it "should know where a given item has already been imported" do
    ImportItem.should_receive(:where).and_return([])
    @item.imported?.should be_false

    ImportItem.should_receive(:where).and_return([1, 2, 3])
    @item.imported?.should be_true
  end

  context "importing item" do
    it "should normalize items not yet imported" do
      @item.should_receive(:imported?).and_return(false)
      @item.should_receive(:normalize!)
      ImportItem.should_receive(:new).and_return(@item)

      ImportItem.import({foo: 'bar'})
    end

    it "should normalize items not yet imported" do
      @item.should_receive(:imported?).and_return(true)
      @item.should_not_receive(:normalize!)
      ImportItem.should_receive(:new).and_return(@item)

      ImportItem.import({foo: 'bar'})
    end
  end

end
