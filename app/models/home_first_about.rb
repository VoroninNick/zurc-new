class HomeFirstAbout < ActiveRecord::Base
  attr_accessible :published, :name, :description, :position

  # translations
  translates :name, :description#, versioning: :paper_trail#, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  globalize_accessors

  class Translation
    attr_accessible :locale
    attr_accessible :name, :description
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

  # scopes
  scope :published, proc { where(published: 't').ordered.limit(4) }
  scope :ordered, proc { order("position asc") }
end
