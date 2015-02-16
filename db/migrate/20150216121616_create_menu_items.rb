class CreateMenuItems < ActiveRecord::Migration
  def up
    create_table :menu_items do |t|
      t.integer :linkable_id
      t.string :linkable_type
      t.string :name
      t.string :link
      t.string :link_source
      t.string :name_source
      t.integer :priority
      t.string :ancestry
      t.timestamps null: false
    end

    MenuItem.create_translation_table!(name: :string, link: :string)
  end

  def down
    MenuItem.drop_translation_table!

    drop_table :menu_items
  end
end
