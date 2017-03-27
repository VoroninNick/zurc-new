class CreateTags < ActiveRecord::Migration
  def up
    create_table :tags do |t|
      t.string :name
      t.string :slug
      t.timestamps null: false
    end

    Tag.create_translation_table(:name, :slug)
  end

  def down
    drop_table :tags

    Tag.drop_translation_table!
  end
end
