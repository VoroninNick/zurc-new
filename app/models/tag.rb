class Tag < ActiveRecord::Base
  # attr_accessible
  attr_accessible :name, :slug

  # translations
  translates :name, :slug#, versioning: :paper_trail#, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  globalize_accessors

  class Translation
    attr_accessible :locale
    attr_accessible :name, :slug

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

  # associations
  has_many :taggings, class: Tagging
  has_many :articles, through: :taggings, source_type: Article, source: :taggable
  has_many :gallery_images, through: :taggings, source_type: GalleryImage, source: :taggable
  has_many :gallery_albums, through: :taggings, source_type: GalleryAlbum, source: :taggable

  def all_taggables
    articles + gallery_images + gallery_albums
  end

  attr_accessible :taggables, :taggings, :taggable_ids, :tagging_ids


end
