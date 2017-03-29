class RenameCmsTagsTables < ActiveRecord::Migration
  def change
    rename_table :tags, :cms_tags
    rename_table :tag_translations, :cms_tag_translations
    rename_table :taggings, :cms_taggings
    add_column :cms_taggings, :taggable_field_name, :string
    rename_column :cms_tag_translations, :tag_id, :cms_tag_id
  end
end
