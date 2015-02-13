class AddImageToArticleCategories < ActiveRecord::Migration
  def change
  	add_column :article_categories, :image, :string
  end
end
