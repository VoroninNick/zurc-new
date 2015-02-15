class GalleryImage < ActiveRecord::Base

  attr_accessible :name, :data, :published, :position, :alt

  # translations
  translates :name, :alt, :data#, versioning: :paper_trail#, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  globalize_accessors

  class Translation
    attr_accessible :locale
    attr_accessible :name, :data

    mount_uploader :data, GalleryUploader


  end

  def get_attr(attr_name, options = {} )
    options[:locales_priority] = [I18n.locale, another_locale] unless options.keys.include?(:locales_priority)
    super(attr_name, options)
  end

  def another_locale
    I18n.available_locales.map(&:to_sym).select {|locale| locale != I18n.locale.to_sym  }.first
  end

  def get_name
    get_attr(:name)
  end

  def get_description
    get_attr(:description)
  end

  def get_data
    get_attr(:data, find_via: [:translations] )
  end


  # associations

  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings

  attr_accessible :taggings, :tagging_ids, :tags, :tag_ids

  if check_tables(:gallery_albums)
    belongs_to :album, class: GalleryAlbum
  end
  attr_accessible :album, :album_id
end
