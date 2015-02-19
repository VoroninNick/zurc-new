class CreateLinks < ActiveRecord::Migration
  def up
    create_table :links do |t|
      t.integer :linkable_id
      t.string :linkable_type
      t.text :content
      t.string :url
      t.boolean :blank_window
      t.boolean :no_follow
      t.string :alt
      t.string :title
      t.string :content_source
      t.string :url_source

      t.integer :owner_id
      t.string :owner_type

      t.timestamps null: false
    end

    Link.create_translation_table!(content: :text, url: :string, alt: :string, title: :string)
  end

  def down
    Link.drop_translation_table!

    drop_table :links
  end

end
