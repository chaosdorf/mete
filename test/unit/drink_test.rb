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
end
