class MenuItem < ActiveRecord::Base
  attr_accessible :linkable_id, :linkable_type, :name, :link, :link_source, :name_source, :priority, :ancestry

  # associations
  belongs_to :linkable, polymorphic: true
  attr_accessible :linkable

  has_ancestry


  # translations
  translates :name, :link#, versioning: :paper_trail#, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  globalize_accessors

  class Translation
    attr_accessible :locale
    attr_accessible :name, :link
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

  def get_link
    get_attr(:link)
  end
end
