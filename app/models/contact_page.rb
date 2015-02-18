class ContactPage < ActiveRecord::Base
  # menu_items
  has_many :menu_items, as: :linkable
  attr_accessible :menu_items, :menu_item_ids

  # page meta_data
  has_one :page_metadata, as: :page
  attr_accessible :page_metadata

  accepts_nested_attributes_for :page_metadata
  attr_accessible :page_metadata_attributes

  attr_accessible :slug

  after_save :reload_routes
  def reload_routes
    Rails.application.class.routes_reloader.reload!
  end

  # translations
  translates :slug#, versioning: :paper_trail#, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  globalize_accessors

  class Translation
    attr_accessible :locale
    attr_accessible :slug
  end

  def get_attr(attr_name, options = {} )
    options[:locales_priority] = [I18n.locale, another_locale] unless options.keys.include?(:locales_priority)
    super(attr_name, options)
  end

  def another_locale
    I18n.available_locales.map(&:to_sym).select {|locale| locale != I18n.locale.to_sym  }.first
  end

  def get_slug(options = {})
    get_attr(:slug, options)
  end

  def routes_module
    Rails.application.routes.url_helpers
  end

  def to_param(options = {})
    options[:locales_priority] = [I18n.locale, another_locale] unless options.keys.include?(:locales_priority)
    options[:locale] = options[:locales_priority].first if options[:locale].blank?

    routes_module.contact_path locale: options[:locale],
                               url: get_slug(options)
  end
end
