class CreateArticleCategories < ActiveRecord::Migration
  def up
    create_table :article_categories do |t|
      t.string :name
      t.string :url_fragment
      t.integer :position
      t.string :ancestry
      t.boolean :published
    end

      ArticleCategory.create_translation_table(:name, :url_fragment)
  end

  def down
    ArticleCategory.drop_translation_table!

    drop_table :article_categories
  end
end
