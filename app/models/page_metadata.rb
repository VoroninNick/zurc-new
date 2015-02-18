class PageMetadata < ActiveRecord::Base
  self.table_name = :page_metadata

  # associations
  belongs_to :page, polymorphic: true
  attr_accessible :page

  attr_accessible :head_title, :meta_keywords, :meta_description, :page_type, :page_id, :template_name

  after_save :reload_routes
  def reload_routes
    Rails.application.class.routes_reloader.reload!
  end

  # translations
  translates :head_title, :meta_keywords, :meta_description#, versioning: :paper_trail#, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  globalize_accessors

  class Translation
    attr_accessible :locale
    attr_accessible :head_title, :meta_keywords, :meta_description


  end

  def get_attr(attr_name, options = {} )
    options[:locales_priority] = [I18n.locale, another_locale] unless options.keys.include?(:locales_priority)
    super(attr_name, options)
  end

  def another_locale
    I18n.available_locales.map(&:to_sym).select {|locale| locale != I18n.locale.to_sym  }.first
  end

  def get_head_title
    get_attr(:head_title)
  end

  def get_meta_keywords
    get_attr(:meta_keywords)
  end

  def get_meta_description
    get_attr(:meta_description)
  end

end
