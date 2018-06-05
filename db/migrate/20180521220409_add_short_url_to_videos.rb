class AddShortUrlToVideos < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :short_url, :string
  end
end
