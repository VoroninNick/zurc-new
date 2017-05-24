class ContactPage < ActiveRecord::Base
  attr_accessible *attribute_names

  # menu_items
  has_many :menu_items, as: :linkable, class_name: MenuItem
  attr_accessible :menu_items, :menu_item_ids

  # linkable
  has_many :links, as: :linkable, class_name: Link
  attr_accessible :links, :link_ids

  has_seo_tags
  has_cache

  attr_accessible :url_fragment

  after_save :reload_routes
  def reload_routes
    Rails.application.class.routes_reloader.reload!
  end

  # translations
  globalize :url_fragment#, versioning: :paper_trail#, fallbacks_for_empty_translations: true


  def get_attr(attr_name, options = {} )
    options[:locales_priority] = [I18n.locale, another_locale] unless options.keys.include?(:locales_priority)
    super(attr_name, options)
  end

  def another_locale
    I18n.available_locales.map(&:to_sym).select {|locale| locale != I18n.locale.to_sym  }.first
  end

  def to_param(options = {})
    options[:locales_priority] = [I18n.locale, another_locale] unless options.keys.include?(:locales_priority)
    options[:locale] = options[:locales_priority].first if options[:locale].blank?

    url_helpers.contact_path locale: options[:locale],
                               url: url_fragment
  end

  def self.url(locale = I18n.locale)
    p = self.first
    return nil if p.blank?

    url_fragment = p.translations_by_locale[locale].try(:url_fragment)
    return nil if url_fragment.blank?

    "/#{locale}/" + url_fragment
  end
end
