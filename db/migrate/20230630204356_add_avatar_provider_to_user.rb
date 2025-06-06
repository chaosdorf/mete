class AddAvatarProviderToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :avatar_provider, :integer, default: 0
    rename_column :users, :email, :avatar
  end
end
