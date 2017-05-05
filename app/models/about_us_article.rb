class AboutUsArticle < Article
  default_scope do
    Article.where(article_category_id: 2)
  end
end