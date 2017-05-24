class CreateTrackings < ActiveRecord::Migration[5.0]
  def change
    create_table :trackings do |t|
      t.belongs_to :link, foreign_key: true
      t.text :referer
      t.text :browser
      t.string :ip
      t.jsonb :ip_data, null: false, default: '{}'
      t.timestamps
    end
  end
end
