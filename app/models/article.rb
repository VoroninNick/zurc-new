class Article < ActiveRecord::Base
  # attr_acceessible
  attr_accessible :name, :description, :intro, :content, :release_date, :slug, :author, :published, :featured, :image

  # associations
  belongs_to :article_category, class: ArticleCategory
  attr_accessible :article_category, :article_category_id

  has_many :attachments, as: :attachable
  accepts_nested_attributes_for :attachments, allow_destroy: true
  attr_accessible :attachments, :attachments_attributes



  # translations
  translates :name, :description, :intro, :content, :slug, :author#, versioning: :paper_trail#, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  globalize_accessors

  class Translation
    attr_accessible :locale
    attr_accessible :name, :description, :intro, :content, :slug, :author

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

  def get_name
    get_attr(:name)
  end

  def get_description
    get_attr(:description)
  end

  def get_intro
    get_attr(:intro)
  end

  def get_content
    get_attr(:content)
  end

  def get_slug
    get_attr(:slug)
  end

  def get_author
    get_attr(:author)
  end

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
  scope :featured, -> { where(featured: 't').order_by_date_desc.limit(3) }
  scope :unfeatured, -> { where.not(id: featured.map(&:id)) }
  scope :by_url, -> (url) { where(slug: url ) }

  # images
  mount_uploader :image, ImageUploader





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
    if (featured = Article.published.publications.featured) && featured.where(id: self.id).any?
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

  def routes_module
    Rails.application.routes.url_helpers
  end

  def to_param
    return routes_module.send("show_publication_path", id: self.get_slug, locale: I18n.locale) if self.publication?
    return routes_module.send("show_news_path", id: self.get_slug, locale: I18n.locale) if self.news?
    return routes_module.send("show_about_path", id: self.get_slug, locale: I18n.locale) if self.about_us?
    return routes_module.send("show_what_we_do_path", id: self.get_slug, locale: I18n.locale) if self.what_we_do?
  end

  def smart_to_param
    routes_module.smart_article_path locale: I18n.locale, url: (article_category.path.map(&:get_slug).select{|slug| slug.present? } << self.get_slug ).join("/")
  end
end
