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
  
  test "should export to json" do
    assert_kind_of Hash, audits(:one).as_json({}), "Failed to export to json"
  end
  
  test "should correctly export to json" do
    j = audits(:one).as_json({})
    assert j.key?('id'), "Failed to export id"
    assert j.key?('created_at'), "Failed to export created_at"
    assert j.key?('difference'), "Failed to export difference"
    assert j.key?('drink'), "Failed to export drink"
    assert_not j.key?('user'), "Exported user"
  end
end
