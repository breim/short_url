class AddTrackingCountToLinks < ActiveRecord::Migration[5.0]
  def change
    add_column :links, :trackings_count, :integer, default: 0
  end
end
