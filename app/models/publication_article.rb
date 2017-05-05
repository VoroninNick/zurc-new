class PublicationArticle < Article
  default_scope do
    Article.where(article_category_id: 4)
  end
end