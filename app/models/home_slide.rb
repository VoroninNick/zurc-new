class HomeSlide < ActiveRecord::Base
  attr_accessible :published, :image, :name, :description, :position, :image_alt

  # translations
  translates :name, :description, :image_alt#, versioning: :paper_trail#, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  globalize_accessors

  class Translation
    attr_accessible :locale
    attr_accessible :name, :description, :image_alt

    before_validation :set_image_alt
    def set_image_alt
      self.image_alt = self.name if self.image_alt.blank?
    end
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

  def get_image_alt
    get_attr(:image_alt)
  end

  # images
  mount_uploader :image, HomeSlideUploader

  # scopes
  scope :published, proc { where(published: 't').ordered.limit(3) }
  scope :ordered, proc { order("position asc") }
end
