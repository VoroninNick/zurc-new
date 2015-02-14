class CreateHomeFirstAbouts < ActiveRecord::Migration
  def up
    create_table :home_first_abouts do |t|
      t.string :name
      t.text :description
      t.boolean :published
      t.integer :position

      t.timestamps null: false
    end

    HomeFirstAbout.create_translation_table!(name: :string, description: :text)
  end

  def down
    HomeFirstAbout.drop_translation_table!

    drop_table :home_first_abouts
  end
end
