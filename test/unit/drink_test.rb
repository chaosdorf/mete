require 'test_helper'

class DrinkTest < ActiveSupport::TestCase
  test "should not save without name" do
    drink = Drink.new
    drink.name = nil
    drink.bottle_size = 0.5
    drink.price = 1.5
    assert_not drink.save, "Saved without a name"
  end
  
  test "should not save without bottle_size" do
    drink = Drink.new
    drink.name = "Test"
    drink.bottle_size = nil
    drink.price = 1.5
    assert_not drink.save, "Saved without bottle_size"
  end
  
  test "should not save without price" do
    drink = Drink.new
    drink.name = "Test"
    drink.bottle_size = 0.5
    drink.price = nil
    assert_not drink.save, "Saved without a price"
  end
  
  test "should save" do
    drink = Drink.new
    drink.name = "Test"
    drink.bottle_size = 0.5
    drink.price = 1.5
    assert drink.save, "Failed to save"
  end
  
  test "should have attributes" do
    d = drinks(:one)
    assert_respond_to d, :id, "id missing"
    assert_respond_to d, :name, "name missing"
    assert_respond_to d, :bottle_size, "bottle_size missing"
    assert_respond_to d, :caffeine, "caffeine missing"
    assert_respond_to d, :price, "price missing"
    assert_respond_to d, :logo_file_name, "logo_file_name missing"
    assert_respond_to d, :created_at, "created_at missing"
    assert_respond_to d, :updated_at, "updated_at missing"
    assert_respond_to d, :logo_content_type, "logo_content_type missing"
    assert_respond_to d, :logo_file_size, "logo_file_size missing"
    assert_respond_to d, :logo_updated_at, "logo_updated_at missing"
    assert_respond_to d, :active, "active missing"
  end
  
  test "should export to json" do
    assert_kind_of Hash, drinks(:one).as_json({}), "Failed to export to json"
  end
  
  test "should correctly export to json" do
    j = drinks(:one).as_json({})
    assert j.key?('id'), "Failed to export id"
    assert j.key?('name'), "Failed to export name"
    assert j.key?('bottle_size'), "Failed to export bottle size"
    assert j.key?('caffeine'), "Failed to export caffeine"
    assert j.key?('price'), "Failed to export price"
    assert j.key?('donation_recommendation'), "Failed to export donation recommendation"
    assert j.key?('logo_file_name'), "Failed to export logo_file_name"
    assert j.key?('created_at'), "Failed to export created_at"
    assert j.key?('updated_at'), "Failed to export updated_at"
    assert j.key?('logo_content_type'), "Failed to export logo_content_type"
    assert j.key?('logo_file_size'), "Failed to export logo_file_size"
    assert j.key?('logo_updated_at'), "Failed to export logo_updated_at"
    assert j.key?('active'), "Failed to export active"
    assert j.key?('logo_url'), "Failed to export logo_url"
  end
end
