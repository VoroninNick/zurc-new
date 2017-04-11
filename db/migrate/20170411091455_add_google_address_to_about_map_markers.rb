class AddGoogleAddressToAboutMapMarkers < ActiveRecord::Migration
  def change
    add_column :about_map_markers, :google_address, :string
  end
end
