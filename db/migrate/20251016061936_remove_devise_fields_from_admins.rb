class RemoveDeviseFieldsFromAdmins < ActiveRecord::Migration[6.1]
  def change
    remove_column :admins, :reset_password_token, :string
    remove_column :admins, :reset_password_sent_at, :datetime
    remove_column :admins, :remember_created_at, :datetime

    # インデックスの削除 (インデックス名は環境により異なる場合があります)
    remove_index(:admins, :reset_password_token, if_exists: true)
    remove_index(:admins, :email, if_exists: true)
  end
end
