class CreateHomeGalleryImages < ActiveRecord::Migration
  def up
    create_table :home_gallery_images do |t|
      t.string :image
      t.integer :position
      t.boolean :published
      t.string :image_alt

      t.timestamps null: false
    end

    HomeGalleryImage.create_translation_table(:image_alt)
  end

  def down
    HomeGalleryImage.drop_translation_table!

    drop_table :home_gallery_images
  end
end
