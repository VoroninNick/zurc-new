class HomeGalleryImage < ActiveRecord::Base
  attr_accessible :published, :position, :image, :image_alt

  # translations
  translates :image_alt#, versioning: :paper_trail#, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  globalize_accessors

  class Translation
    attr_accessible :locale
    attr_accessible :image_alt

    def name
      self.image_alt
    end

    before_validation :set_image_alt
    def set_image_alt
      self.image_alt = "image #{HomeGalleryImage.count + 1}" if self.image_alt.blank?
    end
  end

  def get_attr(attr_name, locales_priority = [I18n.locale, another_locale])
    super(attr_name, locales_priority)
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
