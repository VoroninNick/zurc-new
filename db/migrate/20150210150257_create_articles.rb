class CreateArticles < ActiveRecord::Migration
  def up
    create_table :articles do |t|
      t.string :name
      t.text :description
      t.text :intro
      t.text :content
      t.belongs_to :article_category
      t.datetime :release_date
      t.string :url_fragment
      t.string :author
      t.boolean :published
    end

    Article.create_translation_table(:name, :description, :intro, :content, :url_fragment, :author)
  end

  def down
    Article.drop_translation_table!

    drop_table :articles
  end
end
