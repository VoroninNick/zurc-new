class CreateHomeSecondAbouts < ActiveRecord::Migration
  def up
    create_table :home_second_abouts do |t|
      t.string :name
      t.text :description
      t.boolean :published
      t.integer :position

      t.timestamps null: false
    end

    HomeSecondAbout.create_translation_table(:name, :description)
  end

  def down
    HomeSecondAbout.drop_translation_table!

    drop_table :home_second_abouts
  end
end
