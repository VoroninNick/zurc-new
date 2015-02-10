class CreateArticles < ActiveRecord::Migration
  def up
    create_table :articles do |t|
      t.string :name
      t.text :description
      t.text :intro
      t.text :content
      t.belongs_to :article_category
      t.datetime :release_date
      t.string :slug
      t.string :author
      t.boolean :published
    end

    Article.create_translation_table!(name: :string, description: :text, intro: :text, content: :text, slug: :string, author: :string)
  end

  def down
    Article.drop_translation_table!

    drop_table :articles
  end
end
