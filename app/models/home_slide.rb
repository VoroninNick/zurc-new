class HomeSlide < ActiveRecord::Base
  attr_accessible :url, :published, :image, :name, :description, :position, :image_alt

  # translations
  globalize :name, :description, :image_alt, :url

  def get_attr(attr_name, options = {} )
    options[:locales_priority] = [I18n.locale, another_locale] unless options.keys.include?(:locales_priority)
    super(attr_name, options)
  end

  def another_locale
    I18n.available_locales.map(&:to_sym).select {|locale| locale != I18n.locale.to_sym  }.first
  end

  # images
  mount_uploader :image, HomeSlideUploader

  # scopes
  scope :published, proc { where(published: 't').ordered.limit(3) }
  scope :ordered, proc { order("position asc") }
end
