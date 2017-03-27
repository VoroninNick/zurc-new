class HomeGalleryImage < ActiveRecord::Base
  attr_accessible :published, :position, :image, :image_alt

  # translations
  globalize :image_alt

  def get_attr(attr_name, options = {} )
    options[:locales_priority] = [I18n.locale, another_locale] unless options.keys.include?(:locales_priority)
    super(attr_name, options)
  end

  def another_locale
    I18n.available_locales.map(&:to_sym).select {|locale| locale != I18n.locale.to_sym  }.first
  end

  def get_image_alt
    get_attr(:image_alt)
  end

  def name
    self.image_alt
  end

  # images
  mount_uploader :image, HomeGalleryImageUploader

  # scopes
  scope :published, proc { where(published: 't').ordered.limit(20) }
  scope :ordered, proc { order("position asc") }
end
