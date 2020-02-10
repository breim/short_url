class AddCognitoToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :cognito_id, :string, nil: false, default: ''
    add_column :users, :company, :string, nil: false, default: ''
    remove_column :users, :encrypted_password, :string
    remove_column :users, :reset_password_token, :string
    remove_column :users, :reset_password_sent_at, :datetime
    remove_column :users, :remember_created_at, :datetime
    remove_column :users, :sign_in_count, :integer
  end
end
