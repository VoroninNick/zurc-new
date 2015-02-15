class ArticleCategory < ActiveRecord::Base
  # attr_accessible
  attr_accessible :name, :slug, :published, :position, :ancestry

  # associations
  has_many :articles, class: Article
  attr_accessible :articles, :article_ids

  has_ancestry

  # translations
  translates :name, :slug#, versioning: :paper_trail, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  globalize_accessors

  class Translation
    attr_accessible :locale
    attr_accessible :name, :slug

    before_validation :generate_slug
    def generate_slug
        self.slug = self.name || "" if self.slug.blank?
        self.slug = self.slug.parameterize
    end
  end

  def get_attr(attr_name, options = {} )
    options[:locales_priority] = [I18n.locale, another_locale] unless options.keys.include?(:locales_priority)
    super(attr_name, options)
  end

  def another_locale
    I18n.available_locales.map(&:to_sym).select {|locale| locale != I18n.locale.to_sym  }.first
  end

  def get_name options = {}
    get_attr(:name, options)
  end

  def get_slug options = {}
    get_attr(:slug, options)
  end

  # images
  attr_accessible :image
  mount_uploader :image, ArticleCategoryImageUploader

  scope :about_us_category, proc { where(id: 2).first }
  scope :what_we_do_category, proc { where(id: 3).first }
  scope :not_empty_categories, proc { select {|c| c.articles.any?  } }
  scope :published, proc { where(published: 't') }

  def what_we_do_child?
    ArticleCategory.what_we_do_category.id == self.parent_id
  end

  # def not_empty_categories
  #   children.select {|category|   }
  # end

  def routes_module
    Rails.application.routes.url_helpers
  end

  def to_param
    return routes_module.show_what_we_do_category_path(id: self.get_slug, locale: I18n.locale) if what_we_do_child?
  end

  def find_articles(options = {})
    options[:find_in_descendants] = false unless options.include?(:find_in_descendants)
    search_objects = [self]
    if options[:find_in_descendants]
      search_objects.concat(self.descendants)
    end

    articles = []

    search_objects.each do |search_object|
      articles.concat(search_object.articles.published)
    end

    articles
  end

  def child_categories_with_articles(options = {})
    options[:find_in_descendants] = false unless options.include?(:find_in_descendants)
    self.children.select {|c| c.find_articles( find_in_descendants: options[:find_in_descendants]).any? }
  end

  def smart_to_param(options = {})
    options[:locales_priority] = [I18n.locale, another_locale] if options[:locales_priority].blank?
    options[:locale] = options[:locales_priority].first if options[:locale].blank?
    routes_module.smart_article_path locale: options[:locale], url: (self.path.map{|c| c.get_slug(locales_priority: options[:locales_priority] ) }.select{|slug| slug.present? } ).join("/")
  end

  def find_slug_in_translations(options = {} )
    options[:translations] = [I18n.locale, another_locale] if options[:translations].blank?

    action = :find_slug
    action = :find_translation_with_specified_slug if options[:slug].present?
    if action == :find_slug
    elsif action == :find_translation_with_specified_slug
      self.translations.each do |t|
        next unless t.locale.to_sym.in?(options[:translations].map(&:to_sym))
        return t.locale.to_sym if t.slug == options[:slug]
      end
    end
  end

  def self.available_what_we_do_categories
    ArticleCategory.published.what_we_do_category.child_categories_with_articles(find_in_descendants: true).select{|c| c.published == true }
  end

end


