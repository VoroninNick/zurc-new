class PagesAbout < ActiveRecord::Base
  attr_accessible *attribute_names

  # associations
  #belongs_to :article_category, class: ArticleCategory
  #attr_accessible :article_category, :article_category_id



  # translations
  globalize :content

  # scopes
  scope :published, -> { where(published: 't').order('id desc').first }
end
