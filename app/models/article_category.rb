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

  class Translation
    attr_accessible :locale
    attr_accessible :name, :slug

    before_validation :generate_slug
    def generate_slug
        self.slug = self.name || "" if self.slug.blank?
        self.slug = self.slug.parameterize
    end
  end

  # images
  attr_accessible :image
  mount_uploader :image, ArticleCategoryImageUploader

end
