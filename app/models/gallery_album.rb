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


  # translations
  translates :name, :alt, :image, :slug#, versioning: :paper_trail#, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  globalize_accessors

  class Translation
    attr_accessible :locale
    attr_accessible :name, :image, :alt, :slug

    mount_uploader :image, GalleryUploader

    before_validation :generate_slug
    def generate_slug
      self.slug = self.name || "" if self.slug.blank?
      self.slug = self.slug.parameterize
    end
  end

  def get_attr(attr_name, options = {} )
    options[:locales_priority] = [I18n.locale, another_locale] unless options.keys.include?(:locales_priority)
    super(attr_name, options)
  end

  def another_locale
    I18n.available_locales.map(&:to_sym).select {|locale| locale != I18n.locale.to_sym  }.first
  end

  def get_name(options = {})
    get_attr(:name, options)
  end

  def get_slug(options = {})
    get_attr(:slug, options)
  end

  def get_description(options = {})
    get_attr(:description, options)
  end

  def get_image
    get_attr(:image, find_via: [:translations] )
  end




  def routes_module
    Rails.application.routes.url_helpers
  end

  # associations

  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings

  attr_accessible :taggings, :tagging_ids, :tags, :tag_ids

  if check_tables(:gallery_images)
    has_many :images, class: GalleryImage, foreign_key: :album_id
    attr_accessible :images, :image_ids
  end

  accepts_nested_attributes_for :images
  attr_accessible :images_attributes

  # scopes
  scope :published, -> { where(published: 't') }
  scope :available, -> { published.joins(:images).where(gallery_images: { published: 't' }).where.not(gallery_images: {data: nil}).group("gallery_albums.id") }

  def smart_to_param
    if self.get_slug
      routes_module.gallery_album_path(locale: I18n.locale, album: self.get_slug)
    else
      return nil
    end
  end
end
