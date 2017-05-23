class AddTokenToLinks < ActiveRecord::Migration[5.0]
  def change
    add_column :links, :token, :string
  end
end
