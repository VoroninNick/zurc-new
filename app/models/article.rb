class Article < ActiveRecord::Base
  # attr_acceessible
  attr_accessible :name, :description, :intro, :content, :release_date, :slug, :author, :published, :featured, :image

  # associations
  belongs_to :article_category, class: ArticleCategory
  attr_accessible :article_category, :article_category_id

  # translations
  translates :name, :description, :intro, :content, :slug, :author#, versioning: :paper_trail#, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible :locale
    attr_accessible :name, :description, :intro, :content, :slug, :author

    before_validation :generate_slug
    def generate_slug
      self.slug = self.name || "" if self.slug.blank?
      self.slug = self.slug.parameterize
    end
  end

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
    Article.publications.where(id: self.id).count > 0
  end

  def about_us?
    Article.about_us.where(id: self.id).count > 0
  end

  def what_we_do?
    Article.what_we_do.where(id: self.id).count > 0
  end

  def news?
    Article.news.where(id: self.id).count > 0
  end

  def ad_image_url
    if (featured = Article.published.publications.featured) && (featured.where(id: self.id).length > 0)
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
    routes_module.send("show_publication_path", id: self.translations_by_locale[I18n.locale].slug) if self.publication?
    routes_module.send("show_news_path", id: self.translations_by_locale[I18n.locale].slug) if self.news?
    routes_module.send("show_about_path", id: self.translations_by_locale[I18n.locale].slug) if self.about_us?
  end


end
