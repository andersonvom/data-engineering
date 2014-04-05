require 'spec_helper'

describe Purchase do
  before :each do
    @purchase = Purchase.new
  end

  it "should set the price in cents" do
    @purchase.price = 123.45
    @purchase.price_in_cents.should == 12345
  end

  it "should get the price with cents" do
    @purchase.price_in_cents = 12345
    @purchase.price.should == 123.45
  end
end
