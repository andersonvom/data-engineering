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
    it "should return false if it contains error data" do
      @item.data = 'some error data'
      @item.imported?.should be_false
    end

    it "should return false if it's a new item" do
      @item.id = nil
      @item.imported?.should be_false
    end

    it "should return true if imported and without any errors" do
      @item.id = 100
      @item.imported?.should be_true
    end
  end

  describe "#self.import" do
    before :each do
      ImportItem.should_receive(:get_import_item_for).with({foo: 'bar'}).and_return(@item)
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

  describe "#self.get_import_item_for" do
    it "should find or initialize a new item for the given attributes" do
      import = Import.new
      @attrs = { import: import, line_number: 100, item_price: "99.90" }
      item_search_info = { import: import, line_number: 100 }
      ImportItem.should_receive(:find_or_initialize_by)
                .with(item_search_info)
                .and_return(@item)

      item = ImportItem.get_import_item_for(@attrs)
      item.line_number.should == 100
      item.item_price.should == '99.90'
      item.merchant_address.should == 'address'
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
        @item.data = 'some error data form previous tries'
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
        @item.data.should be_nil
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
