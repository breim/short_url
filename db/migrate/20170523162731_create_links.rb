class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.string :original_url
      t.string :short_url
      t.references :user

      t.timestamps
    end
  end
end
