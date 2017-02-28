require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should not save without name" do
    user = User.new
    assert_not user.save, "Saved the user without a name"
  end
  
  test "should save" do
    user = User.new
    user.name = "test"
    assert user.save, "Failed to save the user with a name"
  end
  
  test "should deposit" do
    assert users(:one).deposit(rand(500)), "Failed to deposit money"
  end
  
  test "depositing should increase balance" do
    user = users(:one)
    amount = rand(500)
    balance_was = user.balance
    user.deposit amount
    assert_equal balance_was + amount, user.balance, "Depositing money didn't increase the balance"
  end
  
  test "should pay" do
    assert users(:one).payment(rand(500)), "Failed to pay"
  end
  
  test "payment should decrease balance" do
    user = users(:one)
    amount = rand(500)
    balance_was = user.balance
    user.payment amount
    assert_equal balance_was - amount, user.balance, "Payment didn't decrease the balance"
  end
  
  test "should buy a drink" do
    assert users(:one).buy(drinks(:one)), "Failed to buy"
  end
  
  test "buying should decrease balance" do
    user = users(:one)
    drink = drinks(:one)
    balance_was = user.balance
    user.buy drink
    assert_equal balance_was - drink.price, user.balance, "Buying didn't decrease the balance"
  end
  
  test "should have attributes" do
    u = users(:one)
    assert_respond_to u, :id, "id missing"
    assert_respond_to u, :name, "name missing"
    assert_respond_to u, :email, "email missing"
    assert_respond_to u, :created_at, "created_at missing"
    assert_respond_to u, :updated_at, "updated_at missing"
    assert_respond_to u, :balance, "balance missing"
    assert_respond_to u, :active, "active missing"
    assert_respond_to u, :audit, "audit missing"
    assert_respond_to u, :redirect, "redirect missing"
  end
  
  test "should export to json" do
    assert_kind_of Hash, users(:one).as_json({}), "Failed to export to json"
  end
  
  test "should correctly export to json" do
    j = users(:one).as_json({})
    assert j.key?('id'), "Failed to export id"
    assert j.key?('name'), "Failed to export name"
    assert j.key?('email'), "Failed to export email"
    assert j.key?('created_at'), "Failed to export created_at"
    assert j.key?('updated_at'), "Failed to export updated_at"
    assert j.key?('balance'), "Failed to export balance"
    assert j.key?('active'), "Failed to export active"
    assert j.key?('audit'), "Failed to export audit"
    assert j.key?('redirect'), "Failed to export redirect"
  end
end
