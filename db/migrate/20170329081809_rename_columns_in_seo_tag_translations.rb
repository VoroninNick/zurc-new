class RenameColumnsInSeoTagTranslations < ActiveRecord::Migration
  def change
    rename_column :seo_tag_translations, :page_metadatum_id, :seo_tag_id

    rename_column :seo_tag_translations, :head_title, :title
    rename_column :seo_tag_translations, :meta_keywords, :keywords
    rename_column :seo_tag_translations, :meta_description, :description
  end
end
