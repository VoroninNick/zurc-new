class CreateAboutMapMarkers < ActiveRecord::Migration
  def up
    create_table :about_map_markers do |t|
      t.boolean :published
      t.string :title
      t.text :address
      t.text :phones
      t.text :fax_phones
      t.text :emails
      t.string :lat_lng
      t.timestamps null: false
    end

    AboutMapMarker.create_translation_table(:title, :address)
  end

  def down
    AboutMapMarker.drop_translation_table!

    drop_table :about_map_markers
  end
end
