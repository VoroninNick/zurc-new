class PagesAbout < ActiveRecord::Base
  # attr_acceessible
  attr_accessible :content, :published

  # associations
  #belongs_to :article_category, class: ArticleCategory
  #attr_accessible :article_category, :article_category_id



  # translations
  globalize :content

  # scopes
  scope :published, -> { where(published: 't').order('id desc').first }
end
