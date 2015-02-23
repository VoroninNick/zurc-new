class AddSlugToGalleryAlbums < ActiveRecord::Migration
  def up
    add_column :gallery_albums, :slug, :string
    add_column GalleryAlbum.translation_class.table_name, :slug, :string
  end

  def down
    remove_column :gallery_albums, :slug
    remove_column GalleryAlbum.translation_class.table_name, :slug
  end
end
