class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :balance_cents
      t.timestamps null: true
    end
  end
end
