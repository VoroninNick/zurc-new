class GalleryAlbum < ActiveRecord::Base
  attr_accessible *attribute_names

  # menu_items
  has_many :menu_items, as: :linkable
  attr_accessible :menu_items, :menu_item_ids

  # page meta_data
  has_seo_tags

  globalize :name, :alt, :image, :url_fragment




  # associations

  has_tags

  if check_tables(:gallery_images)
    has_many :images, class_name: GalleryImage, foreign_key: :album_id
    attr_accessible :images, :image_ids
    accepts_nested_attributes_for :images
    attr_accessible :images_attributes

  end



  # scopes
  scope :published, -> { where(published: 't') }
  #scope :available, -> { published.joins(images: :translations).where(gallery_images: { published: 't' }).where.not(gallery_image_translations: {data: nil}).group("gallery_albums.id") }
  scope :available, -> { published }

  has_cache

  def smart_to_param
    if self.url_fragment
      url_helpers.gallery_album_path(locale: I18n.locale, album: self.url_fragment)
    else
      return nil
    end
  end

  def image(version = :thumb)
    images = try(:images).try{|images| images.select{|i| i.image(version).file } }
    images.first.try(:image, version)
  end

  def image_url(version = :thumb)
    image(version).try{|img| img.url }
  end
end
