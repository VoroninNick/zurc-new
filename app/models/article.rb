class Article < ActiveRecord::Base
  attr_accessible :name, :description, :intro, :content, :release_date, :slug, :author, :published


  translates :name, :description, :intro, :content, :slug, :author
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible :locale
    attr_accessible :name, :description, :intro, :content, :slug, :author
  end

  belongs_to :article_category, class: ArticleCategory
  attr_accessible :article_category, :article_category_id
end