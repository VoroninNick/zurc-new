class CreateGalleryAlbums < ActiveRecord::Migration
  def up
    create_table :gallery_albums do |t|
      t.string :image
      t.string :alt
      t.string :name
      t.boolean :published
      t.integer :position

      t.timestamps null: false
    end

    GalleryAlbum.create_translation_table(:name, :alt, :image)
  end

  def down
    drop_table :gallery_albums

    GalleryAlbum.drop_translation_table!
  end
end
