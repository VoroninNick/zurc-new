class Article < ActiveRecord::Base
  # attr_acceessible
  attr_accessible *attribute_names

  # associations
  belongs_to :article_category, class_name: ArticleCategory
  attr_accessible :article_category, :article_category_id

  has_many :attachments, as: :attachable
  accepts_nested_attributes_for :attachments, allow_destroy: true
  attr_accessible :attachments, :attachments_attributes

  # tags

  has_tags

  # menu_items
  has_many :menu_items, as: :linkable, class_name: MenuItem
  attr_accessible :menu_items, :menu_item_ids

  # linkable
  has_many :links, as: :linkable, class_name: Link
  attr_accessible :links, :link_ids

  # page meta_data
  has_seo_tags

  has_cache


  # translations
  globalize :name, :description, :intro, :content, :url_fragment, :author#, versioning: :paper_trail#, fallbacks_for_empty_translations: true


  # def with_translation(locale = I18n.locale )
  #   self.class.translated_attribute_names.each do |attr_name|
  #     attr_value = self.translations_by_locale[locale].send(attr_name)
  #     #self.send("#{attr_name}=", attr_value)
  #     method_source = "def #{attr_name};#{return "\"#{attr_value}\"" if attr_value.is_a?(String); "#{ attr_value }" };end;"
  #     self.class.class_eval(method_source)
  #   end
  #
  #   return self
  # end

  # scopes
    scope :publications, proc { where(article_category_id: 4 ) }
  #scope :publications_exclude_ads, ->(ads = ArticleAd.ads) { publications.select {|p| used = false; ads.map {|ad| used = true if ad.article_id == p.id   }; !used  } }
  #scope :publications_exclude_ads, ->(ads = ArticleAd.ads || [] ) { ads = ArticleAd.ads || [] if ads.nil?; publications.where.not(id: ads.map(&:article_id) )  }
  scope :about_us, proc { where(article_category_id: 2) }
  scope :what_we_do, proc { where(article_category_id: 3) }
  scope :news, proc { where(article_category_id: 1) }
  scope :published, proc { where(published: 't') }
  scope :unpublished, proc { where.not(published: 't') }
  scope :order_by_date_desc, -> { order('release_date desc') }
  scope :order_by_date_asc, -> { order('release_date asc') }
  scope :featured, -> { where(featured: 't').order_by_date_desc.limit(3) }
  scope :unfeatured, -> { where.not(id: featured.map(&:id)) }
  scope :by_url, -> (url) { where(url_fragment: url ) }
  scope :available, proc { published }

  # images
  mount_uploader :image, ImageUploader


  # def self.publications
  #   Article.all.select{|a| a.publication? }
  # end


  def publication?
    Article.publications.where(id: self.id).any?
  end

  def about_us?
    Article.about_us.where(id: self.id).any?
  end

  def what_we_do?
    Article.what_we_do.where(id: self.id).any?
  end

  def news?
    Article.news.where(id: self.id).any?
  end

  def ad_image_url
    if (featured = Article.publications.featured) && featured.where(id: self.id).any?
      method = nil
      if featured.first.id == self.id
        method = :featured_article_large
      else
        method  = :featured_article_small
      end
      if self.image.send(method).url.present?
        self.image.send(method).url
      else
        if method == :featured_article_large
          "http://placehold.it/800x400/aaa/fff.png"
        else
          "http://placehold.it/360x180/aaa/fff.png"
        end
      end
    else
      nil
    end
  end

  before_save :initialize_release_date

  def initialize_release_date
    self.release_date = DateTime.now if self.release_date.blank?

    true
  end

  def available?
    published?
  end

  def to_param(options = {})
    #return routes_module.send("show_publication_path", id: self.get_url_fragment, locale: I18n.locale) if self.publication?
    # return routes_module.send("show_smart_article_path", id: self.get_url_fragment, locale: I18n.locale) if self.publication?
    # return routes_module.send("show_news_path", id: self.get_url_fragment, locale: I18n.locale) if self.news?
    # return routes_module.send("show_about_path", id: self.get_url_fragment, locale: I18n.locale) if self.about_us?
    # return routes_module.send("show_what_we_do_path", id: self.get_url_fragment, locale: I18n.locale) if self.what_we_do?
    smart_to_param(options)
  end

  def smart_to_param(options = {})
    locale = options[:locale] || I18n.locale
    if !locale.in?(Cms.config.provided_locales)
      return nil
    end

    url_helpers.smart_article_path({locale: locale,
                                     root_category: article_category.try {|category| category.root.url_fragment(locale) } ,
                                     url: (article_category.try{|c| c.path.select{|c| !c.root? }.map{|c| c.url_fragment(locale) }.select{|url_fragment| url_fragment.present? } << self.url_fragment(locale)} ).try(:join, "/")
    }) rescue nil
  end

  def url(locale = I18n.locale)
    smart_to_param(locale: locale)
  end

  def smart_breadcrumbs
    breadcrumbs = []
    path = self.article_category.path
    path_length = path.length
    path.each do |c|
      crumb = {}
      crumb[:title] = c.name
      crumb[:url] = c.smart_to_param
      breadcrumbs << crumb
    end

    breadcrumbs << {title: self.name}

    breadcrumbs
  end

  def geography?
    self.id == 18
  end

  def team?
    self.id == 16
  end


end
