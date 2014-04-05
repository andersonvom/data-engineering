require 'spec_helper'

describe MerchantLocation do
  before :each do
    @location = MerchantLocation.new
    @item = InventoryItem.new
  end

  it "should create inventory items if they don't exist" do
    all_items = @location.inventory_items
    all_items.should_receive(:find_or_initialize_by).and_return(@item)
    @item.should_receive(:save)
    @location.create_or_update_inventory_item(@item, 10)
    @item.price.should == 10
  end

  it "should update inventory item price if they exist" do
    @item.price = 10
    all_items = @location.inventory_items
    all_items.should_receive(:find_or_initialize_by).and_return(@item)
    @item.should_receive(:save)
    @location.create_or_update_inventory_item(@item, 20)
    @item.price.should == 20
  end
end
