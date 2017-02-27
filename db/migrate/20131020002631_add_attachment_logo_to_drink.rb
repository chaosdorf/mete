class AddAttachmentLogoToDrink < ActiveRecord::Migration[4.2]
  def self.up
    add_column :drinks, :logo_content_type, :string
    add_column :drinks, :logo_file_size, :integer
    add_column :drinks, :logo_updated_at, :datetime
  end

  def self.down
    remove_column :drinks, :logo_content_type
    remove_column :drinks, :logo_file_size
    remove_column :drinks, :logo_updated_at
  end
end
