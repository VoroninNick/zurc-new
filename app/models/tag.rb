class Tag < ActiveRecord::Base
  # attr_accessible
  attr_accessible :name, :slug

  # translations
  globalize :name, :slug

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

  #tables = ActiveRecord::Base.connection.tables; [:articles, :gallery_images].select {|t| t.to_s.in?(tables) }

 if check_tables(:gallery_images, :gallery_albums)
    has_many :taggings, class: Tagging
    has_many :articles, through: :taggings, source_type: Article, source: :taggable
    has_many :gallery_images, through: :taggings, source_type: GalleryImage, source: :taggable
    has_many :gallery_albums, through: :taggings, source_type: GalleryAlbum, source: :taggable
 end

  def all_taggables
    articles + gallery_images + gallery_albums
  end

  attr_accessible :taggables, :taggings, :taggable_ids, :tagging_ids


  scope :available, proc { joins(:taggings) }
  scope :available_for, ->(records){ records.empty? ? available : available.where(taggings: { taggable_type: records.map{|a| a.class.to_s }, taggable_id: records.map(&:id) }).group("tags.id") }

  # scope :with_translations, ->(*locales) do
  #
  #   locales.select! {|locale| locale.to_sym.in? I18n.available_locales.map(&:to_sym) }
  #
  #   if locales.any?
  #   else
  #     return joins(:tag_translations)
  #   end
  # end
end
