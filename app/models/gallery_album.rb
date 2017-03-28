class GalleryAlbum < ActiveRecord::Base
  attr_accessible :name, :image, :published, :position, :alt, :url_fragment

  # menu_items
  has_many :menu_items, as: :linkable
  attr_accessible :menu_items, :menu_item_ids

  # page meta_data
  has_seo_tags

  globalize :name, :alt, :image, :url_fragment




  # associations

  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings

  attr_accessible :taggings, :tagging_ids, :tags, :tag_ids

  if check_tables(:gallery_images)
    has_many :images, class_name: GalleryImage, foreign_key: :album_id
    attr_accessible :images, :image_ids
    accepts_nested_attributes_for :images
    attr_accessible :images_attributes

  end



  # scopes
  scope :published, -> { where(published: 't') }
  scope :available, -> { published.joins(images: :translations).where(gallery_images: { published: 't' }).where.not(gallery_image_translations: {data: nil}).group("gallery_albums.id") }

  def smart_to_param
    if self.url_fragment
      routes_module.gallery_album_path(locale: I18n.locale, album: self.url_fragment)
    else
      return nil
    end
  end
end
