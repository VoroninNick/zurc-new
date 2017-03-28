class NewsArticle < Article
  default_scope do
    Article.where(article_category_id: 1)
  end
end