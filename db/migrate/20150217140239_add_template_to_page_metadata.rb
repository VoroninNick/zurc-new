class AddTemplateToPageMetadata < ActiveRecord::Migration
  def change
    add_column :page_metadata, :template_name, :string
  end
end
