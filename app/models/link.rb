class Link < ActiveRecord::Base
  attr_accessible *attribute_names

  belongs_to :linkable, polymorphic: true
  attr_accessible :linkable

  belongs_to :owner, polymorphic: true
  attr_accessible :owner, :owner_id, :owner_type

  # translations
  globalize :content, :url, :alt, :title#, versioning: :paper_trail#, fallbacks_for_empty_translations: true



  def content(options = {} )
    return get_attr(:content) if self.content_source == "custom" && self.get_attr(:content, locales_priority: options[:locales_priority]).present?
    return linkable.name if self.linkable && self.linkable.respond_to?(:name) && self.linkable.name.present?

    return "#{self.class.to_s}##{self.id}"
  end

  def url(options = {})
    options[:locales_priority] = [I18n.locale, another_locale] unless options.keys.include?(:locales_priority)
    return get_attr(:url, locales_priority: options[:locales_priority]) if self.url_source == "custom" && self.get_attr(:url, locales_priority: options[:locales_priority]).present?
    return linkable.to_param if self.linkable && self.linkable.to_param.present?
    return nil
  end

  # activerecord callbacks
  before_validation :init_fields
  def init_fields
    self.url_source = "association" unless self.url_source.to_s.in?(['custom', 'association'])
    self.content_source = "association" unless self.content_source.to_s.in?(['custom', 'association'])
  end
end
