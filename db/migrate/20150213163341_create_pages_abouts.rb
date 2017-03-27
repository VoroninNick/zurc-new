class CreatePagesAbouts < ActiveRecord::Migration
  def up
    create_table :pages_abouts do |t|
      t.boolean :published
      t.text :content
      t.timestamps null: false
    end

    PagesAbout.create_translation_table(:content)
  end

  def down
    PagesAbout.drop_translation_table!

    drop_table :pages_abouts
  end
end
