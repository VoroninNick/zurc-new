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

    PageMetada.create_translation_table!(head_title: :string, meta_keywords: :text, meta_description: :text)


  end

  def down
    PageMetada.drop_translation_table!

    drop_table :page_metadata
  end
end
