class AddDisabledToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :disabled, :boolean, default: true
  end
end
