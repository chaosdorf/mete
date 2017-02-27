class CreateAudits < ActiveRecord::Migration[4.2]
  def change
    create_table :audits do |t|
      t.integer :difference_cents
      t.datetime :created_at
    end
  end
end
