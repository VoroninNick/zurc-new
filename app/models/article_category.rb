class ArticleCategory < ActiveRecord::Base
  # attr_accessible
  attr_accessible *attribute_names

  # associations
  has_many :articles, class_name: Article
  attr_accessible :articles, :article_ids

  has_ancestry

  # menu_items
  has_many :menu_items, as: :linkable, class_name: MenuItem
  attr_accessible :menu_items, :menu_item_ids

  # linkable
  has_many :links, as: :linkable, class_name: Link
  attr_accessible :links, :link_ids

  has_seo_tags
  has_cache

  after_save :reload_routes
  def reload_routes
    Rails.application.class.routes_reloader.reload!
  end

  # translations
  globalize :name, :url_fragment#, versioning: :paper_trail, fallbacks_for_empty_translations: true

  def another_locale
    I18n.available_locales.map(&:to_sym).select {|locale| locale != I18n.locale.to_sym  }.first
  end

  # images
  attr_accessible :image
  mount_uploader :image, ArticleCategoryImageUploader

  scope :news_category, proc { where(id: 1).first }
  scope :about_us_category, proc { where(id: 2).first }
  scope :what_we_do_category, proc { where(id: 3).first }
  scope :publications_category, proc { where(id: 4).first }
  scope :not_empty_categories, proc { select {|c| c.articles.any?  } }
  scope :published, proc { where(published: 't') }

  def news_category?
    c = ArticleCategory.news_category
    c ? c.id == self.id : false
  end

  def about_us_category?
    c = ArticleCategory.about_us_category
    c ? c.id == self.id : false
  end

  def what_we_do_category?
    c = ArticleCategory.what_we_do_category
    c ? c.id == self.id : false
  end

  def publications_category?
    c = ArticleCategory.publications_category
    c ? c.id == self.id : false
  end


  def what_we_do_child?
    ArticleCategory.what_we_do_category.id == self.parent_id
  end

  # def not_empty_categories
  #   children.select {|category|   }
  # end

  def to_param(options = {})
    #return routes_module.show_what_we_do_category_path(id: self.get_url_fragment, locale: I18n.locale) if what_we_do_child?
    smart_to_param(options)
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
    options[:locale] = I18n.locale if options[:locale].blank?
    url_routes.smart_article_path locale: options[:locale],
                                     root_category: self.try {|c| c.root.url_fragment } ,
                                     url: (self.path.select{|c| !c.root? }.map{|c| c.url_fragment }.select{|url_fragment| url_fragment.present? } ).join("/")
  end

  def find_url_fragment_in_translations(options = {} )
    options[:translations] = [I18n.locale, another_locale] if options[:translations].blank?

    action = :find_url_fragment
    action = :find_translation_with_specified_url_fragment if options[:url_fragment].present?
    if action == :find_url_fragment
    elsif action == :find_translation_with_specified_url_fragment
      self.translations.each do |t|
        next unless t.locale.to_sym.in?(options[:translations].map(&:to_sym))
        return t.locale.to_sym if t.url_fragment == options[:url_fragment]
      end
    end
  end

  def self.available_root_categories
    ArticleCategory.roots.published.select{|root_category| root_category.child_categories_with_articles(find_in_descendants: true).select{|c| c.published == true }.any? }
  end

  def available?(options = {})
    return false unless self.published?
    return true if self.articles.published.any?
    options[:find_in_descendants] = true unless options.keys.include?(:find_in_descendants)
    return false if options[:find_in_descendants] == false
    self.descendants.each do |c|
      return true if c.articles.published.any?
    end

    return false
  end

  def available_child_categories
    self.children.select {|c| c.available? }
  end

  def self.available_roots
    self.roots.select{|c| c.available? }
  end

  def available_articles
    self.articles.select{|a| a.available?  }
  end

  def available_articles?(options = {})
    options[:find_in_descendants] = false unless options.keys.include?(:find_in_descendants)

  end

  def self.available_what_we_do_categories
    ArticleCategory.published.what_we_do_category.child_categories_with_articles(find_in_descendants: true).select{|c| c.published == true }
  end

  def smart_breadcrumbs
    breadcrumbs = []
    path = self.path
    path_length = path.length
    path.each do |c|
      crumb = {}
      crumb[:title] = c.name
      crumb[:url] = c.smart_to_param unless c.id == self.id
      breadcrumbs << crumb
    end

    breadcrumbs
  end

end


