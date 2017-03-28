class CreateTags < ActiveRecord::Migration
  def up
    create_table :tags do |t|
      t.string :name
      t.string :url_fragment
      t.timestamps null: false
    end

    Tag.create_translation_table(:name, :url_fragment)
  end

  def down
    drop_table :tags

    Tag.drop_translation_table!
  end
end
