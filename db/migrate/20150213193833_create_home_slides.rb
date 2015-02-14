class CreateHomeSlides < ActiveRecord::Migration
  def up
    create_table :home_slides do |t|
      t.boolean :published
      t.string :image
      t.string :image_alt
      t.string :name
      t.text :description
      t.integer :position
      t.timestamps null: false
    end

    HomeSlide.create_translation_table!(name: :string, description: :string, image_alt: :string)
  end

  def down
    HomeSlide.drop_translation_table!

    drop_table :home_slides
  end
end
