require 'spec_helper'

describe InventoryItem do
  before :each do
    @inventory_item = InventoryItem.new
  end

  it "should set the price in cents" do
    @inventory_item .price = 123.45
    @inventory_item.price_in_cents.should == 12345
  end

  it "should get the price with cents" do
    @inventory_item.price_in_cents = 12345
    @inventory_item.price.should == 123.45
  end
end
