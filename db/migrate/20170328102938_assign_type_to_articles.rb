class AssignTypeToArticles < ActiveRecord::Migration
  def up
    Article.where("article_category_id is not null").each do |a|
      c = a.article_category.try(:root)
      type = "NewsArticle" if c.id == 1
      type = "AboutUsArticle" if c.id == 2
      type = "WhatWeDoArticle" if c.id == 3
      type = "PublicationArticle" if c.id == 4
      #a.update_attributes(type: type)
      a.type = type
      a.save
    end
  end
end
