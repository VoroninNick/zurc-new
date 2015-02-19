class Link < ActiveRecord::Base
  attr_accessible :linkable_id, :linkable_type, :content, :url, :blank_window, :no_follow, :alt, :title, :name_source, :link_source

  belongs_to :linkable, polymorphic: true
  attr_accessible :linkable

  # translations
  translates :content, :url, :alt, :title#, versioning: :paper_trail#, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  globalize_accessors

  class Translation
    attr_accessible :locale
    attr_accessible :content, :url, :alt, :title
  end

  def get_attr(attr_name, options = {} )
    options[:locales_priority] = [I18n.locale, another_locale] unless options.keys.include?(:locales_priority)
    super(attr_name, options)
  end

  def another_locale
    I18n.available_locales.map(&:to_sym).select {|locale| locale != I18n.locale.to_sym  }.first
  end

  def get_content(options = {} )
    #return "test"
    options[:locales_priority] = [I18n.locale, another_locale] unless options.keys.include?(:locales_priority)
    return get_attr(:content) if self.content_source == "custom" && self.get_attr(:content, locales_priority: options[:locales_priority]).present?
    return linkable.get_name(locales_priority: options[:locales_priority]) if self.linkable && self.linkable.respond_to?(:get_name) && self.linkable.get_name(locales_priority: options[:locales_priority]).present?

    return "#{self.class.to_s}##{self.id}"
  end

  def get_url(options = {})
    options[:locales_priority] = [I18n.locale, another_locale] unless options.keys.include?(:locales_priority)
    return get_attr(:url, locales_priority: options[:locales_priority]) if self.link_source == "custom" && self.get_attr(:url, locales_priority: options[:locales_priority]).present?
    return linkable.to_param(locales_priority: options[:locales_priority]) if self.linkable && self.linkable.to_param(locales_priority: options[:locales_priority]).present?
    return nil
  end
end
