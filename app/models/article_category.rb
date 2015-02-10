class ArticleCategory < ActiveRecord::Base
  attr_accessible :name, :slug, :published, :position, :ancestry

  translates :name, :slug
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible :locale
    attr_accessible :name, :slug
  end

  has_many :articles, class: Article
  attr_accessible :articles, :article_ids
end