class PagesAbout < ActiveRecord::Base
  # attr_acceessible
  attr_accessible :content, :published

  # associations
  #belongs_to :article_category, class: ArticleCategory
  #attr_accessible :article_category, :article_category_id



  # translations
  translates :content#, versioning: :paper_trail#, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  globalize_accessors

  class Translation
    attr_accessible :locale
    attr_accessible :content
  end

  def get_attr(attr_name, options = {} )
    options[:locales_priority] = [I18n.locale, another_locale] unless options.keys.include?(:locales_priority)
    super(attr_name, options)
  end

  def another_locale
    I18n.available_locales.map(&:to_sym).select {|locale| locale != I18n.locale.to_sym  }.first
  end

  def get_content
    get_attr(:content)
  end

  # scopes
  scope :published, -> { where(published: 't').order('id desc').first }
end
