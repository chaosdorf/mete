class AddDrinkToAudits < ActiveRecord::Migration[4.2]
  def change
    add_column :audits, :drink, :int
  end
end
