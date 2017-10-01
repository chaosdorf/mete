require 'test_helper'

class AuditTest < ActiveSupport::TestCase
  test "should save" do
    audit = Audit.new
    assert audit.save, "Failed to save"
  end
  
  test "should have attributes" do
    a = audits(:one)
    assert_respond_to a, :id, "id missing"
    assert_respond_to a, :created_at, "created_at missing"
    assert_respond_to a, :difference, "difference missing"
    assert_respond_to a, :drink, "drink missing"
    assert_respond_to a, :user, "user missing"
  end
end
