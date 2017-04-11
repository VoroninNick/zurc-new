class AddLatLngColumnsToAboutMapMarkers < ActiveRecord::Migration
  def change
    add_column :about_map_markers, :lat, :string
    add_column :about_map_markers, :lon, :string
  end
end
