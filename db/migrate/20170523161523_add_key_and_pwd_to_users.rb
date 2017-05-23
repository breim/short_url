class AddKeyAndPwdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :key, :string
    add_column :users, :pwd, :string
  end
end
