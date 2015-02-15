class CreateGalleryImages < ActiveRecord::Migration
  def up
    create_table :gallery_images do |t|
      t.integer :position
      t.string :data
      t.string :name
      t.string :alt
      t.integer :album_id
      t.boolean :published
      t.timestamps null: false
    end

    GalleryImage.create_translation_table!(name: :string, alt: :string, data: :string)
  end

  def down
    drop_table :gallery_images

    GalleryImage.drop_translation_table!
  end
end
