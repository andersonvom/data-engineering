require 'spec_helper'

describe ImportItem do

  before :each do
    @item = ImportItem.new(
      purchaser_name: 'purchaser', item_description: 'desc',
      item_price: '10.50', purchase_count: '5',
      merchant_address: 'address', merchant_name: 'merchant'
    )
  end

  describe "#imported?" do
    it "should return false if item not in DB" do
      ImportItem.should_receive(:find_by).and_return(nil)
      @item.imported?.should be_false
    end

    it "should return false if item has no error data" do
      @item.data = "foo error"
      ImportItem.should_receive(:find_by).and_return(@item)
      @item.imported?.should be_false
    end

    it "should return true if item in DB and no error data" do
      ImportItem.should_receive(:find_by).and_return(@item)
      @item.imported?.should be_true
    end
  end

  describe "#self.import" do
    before :each do
      ImportItem.should_receive(:new).and_return(@item)
    end

    it "should skip items already normalized and log it" do
      @item.should_receive(:imported?).and_return(true)
      @item.should_not_receive(:normalize!)
      ImportItem.import({foo: 'bar'})
    end

    it "should normalize items not yet imported" do
      @item.should_receive(:imported?).and_return(false)
      @item.should_receive(:normalize!)
      ImportItem.import({foo: 'bar'})
    end
  end

  describe "#normalize!" do
    context "success" do
      it "should import item information" do
        @item.should_receive(:import_info!)
        @item.normalize!
      end

      it "should import item information in a transaction" do
        @item.should_receive(:transaction)
        @item.normalize!
      end

      it "should import item information in a transaction" do
        @item.import = Import.new
        @item.should_receive(:save)
        purchaser = Purchaser.new
        merchant = Merchant.new
        location = merchant.locations.new
        item = merchant.items.new
        inventory_item = location.inventory_items.new item: item,
                                                      price_in_cents: 1050

        Purchaser.should_receive(:find_or_create_by)
                 .with(name: 'purchaser')
                 .and_return(purchaser)
        Merchant.should_receive(:find_or_create_by)
                .with(name: 'merchant')
                .and_return(merchant)
        merchant.locations.should_receive(:find_or_create_by)
                          .with(address: 'address')
                          .and_return(location)
        merchant.items.should_receive(:find_or_create_by)
                      .with(description: 'desc')
                      .and_return(item)
        location.should_receive(:create_or_update_inventory_item)
                .with(item, '10.50')
                .and_return(inventory_item)

        Purchase.should_receive(:create).with(
          import: @item.import,
          purchaser: purchaser,
          inventory_item: inventory_item,
          count: '5',
        )

        @item.normalize!
      end
    end

    context "error" do
      before :each do
        @item.should_receive(:import_info!).and_raise
      end

      it "should save error data in error occurs" do
        @item.should_receive(:save_data_for_logs!)
        @item.normalize!
      end

      it "should save all attributes in CSV" do
        @item.should_receive(:save)
        @item.normalize!
        @item.data.should == "purchaser,desc,10.50,5,address,merchant\n"
      end
    end
  end
end
