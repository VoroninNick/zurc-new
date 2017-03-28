class Addurl_fragmentToGalleryAlbums < ActiveRecord::Migration
  def up
    add_column :gallery_albums, :url_fragment, :string
    add_column GalleryAlbum.translation_class.table_name, :url_fragment, :string
  end

  def down
    remove_column :gallery_albums, :url_fragment
    remove_column GalleryAlbum.translation_class.table_name, :url_fragment
  end
end
