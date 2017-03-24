require 'test_helper'

class BarcodeTest < ActiveSupport::TestCase
  test "should not save without id" do
    barcode = Barcode.new
    barcode.id = nil
    barcode.drink = 1
    assert_not barcode.save, "Saved without an id"
  end
  
  test "should not save without drink" do
    barcode = Barcode.new
    barcode.id = "234def"
    barcode.drink = nil
    assert_not barcode.save, "Saved without a drink"
  end
  
  test "should save" do
    barcode = Barcode.new
    barcode.id = "234def"
    barcode.drink = 1
    assert barcode.save, "Failed to save"
  end
  
  test "should not save to barcodes with the same id" do
    barcode1 = Barcode.new
    barcode1.id = "567ghi"
    barcode1.drink = 1
    assert barcode1.save, "Failed to save first barcode with the same id"
    barcode2 = Barcode.new
    barcode2.id = "567ghi"
    barcode2.drink = 2
    assert_raises ActiveRecord::RecordNotUnique, "Saved two barcodes with the same id" do
      assert_not barcode2.save, "Saved two barcodes with the same id"
    end
  end
  
  test "should have attributes" do
    b = barcodes(:one)
    assert_respond_to b, :id, "id missing"
    assert_respond_to b, :drink, "drink missing"
  end
  
  test "should export to json" do
    assert_kind_of Hash, barcodes(:one).as_json({}), "Failed to export to json"
  end
  
  test "should correctly export to json" do
    j = barcodes(:one).as_json({})
    assert j.key?('id'), "Failed to export id"
    assert j.key?('drink'), "Failed to export drink"
  end
end
