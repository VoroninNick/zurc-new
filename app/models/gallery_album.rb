class GalleryAlbum < ActiveRecord::Base
  attr_accessible :name, :image, :published, :position, :alt, :slug

  # menu_items
  has_many :menu_items, as: :linkable
  attr_accessible :menu_items, :menu_item_ids

  # page meta_data
  has_one :page_metadata, as: :page
  attr_accessible :page_metadata

  accepts_nested_attributes_for :page_metadata
  attr_accessible :page_metadata_attributes

  globalize :name, :alt, :image, :slug

  def another_locale
    I18n.available_locales.map(&:to_sym).select {|locale| locale != I18n.locale.to_sym  }.first
  end




  # associations

  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings

  attr_accessible :taggings, :tagging_ids, :tags, :tag_ids

  if check_tables(:gallery_images)
    has_many :images, class: GalleryImage, foreign_key: :album_id
    attr_accessible :images, :image_ids
    accepts_nested_attributes_for :images
    attr_accessible :images_attributes

  end



  # scopes
  scope :published, -> { where(published: 't') }
  scope :available, -> { published.joins(images: :translations).where(gallery_images: { published: 't' }).where.not(gallery_image_translations: {data: nil}).group("gallery_albums.id") }

  def smart_to_param
    if self.get_slug
      routes_module.gallery_album_path(locale: I18n.locale, album: self.get_slug)
    else
      return nil
    end
  end
end
