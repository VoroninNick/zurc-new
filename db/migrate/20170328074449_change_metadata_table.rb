class ChangeMetadataTable < ActiveRecord::Migration
  def change
    rename_table :page_metadata, :seo_tags
    rename_table :page_metadatum_translations, :seo_tag_translations

    rename_column :seo_tags, :head_title, :title
    rename_column :seo_tags, :meta_keywords, :keywords
    rename_column :seo_tags, :meta_description, :description
  end
end
