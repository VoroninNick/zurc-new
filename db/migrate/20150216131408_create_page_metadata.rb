class CreatePageMetadata < ActiveRecord::Migration
  def up
    create_table :page_metadata do |t|
      t.string :head_title
      t.text :meta_keywords
      t.text :meta_description
      t.string :page_type
      t.integer :page_id

      t.timestamps null: false
    end

    PageMetadata.create_translation_table(:head_title, :meta_keywords, :meta_description)


  end

  def down
    PageMetadata.drop_translation_table!

    drop_table :page_metadata
  end
end
