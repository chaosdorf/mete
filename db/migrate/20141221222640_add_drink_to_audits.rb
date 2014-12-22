class AddDrinkToAudits < ActiveRecord::Migration
  def change
    add_column :audits, :drink, :int
  end
end
