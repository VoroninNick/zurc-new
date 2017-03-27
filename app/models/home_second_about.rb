class HomeSecondAbout < ActiveRecord::Base
  attr_accessible :published, :name, :description, :position

  # link
  has_one :link, as: :owner, class: Link
  attr_accessible :link
  accepts_nested_attributes_for :link
  attr_accessible :link_attributes
  delegate :get_url, :get_content, to: :link

  # translations
  globalize :name, :description


  def get_attr(attr_name, options = {} )
    options[:locales_priority] = [I18n.locale, another_locale] unless options.keys.include?(:locales_priority)
    super(attr_name, options)
  end

  def another_locale
    I18n.available_locales.map(&:to_sym).select {|locale| locale != I18n.locale.to_sym  }.first
  end

  # scopes
  scope :published, proc { where(published: 't').ordered.limit(4) }
  scope :ordered, proc { order("position asc") }
end
