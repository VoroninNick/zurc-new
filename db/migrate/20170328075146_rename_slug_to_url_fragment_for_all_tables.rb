class RenameSlugToUrlFragmentForAllTables < ActiveRecord::Migration
  def up
    Cms.tables.each do |table_name|
      if Cms.column_names(table_name).include?("slug")
        rename_column table_name, "slug", "url_fragment"
      end
    end
  end

  def down
    Cms.tables.each do |table_name|
      if Cms.column_names(table_name).include?("url_fragment")
        rename_column table_name, "url_fragment", "slug"
      end
    end
  end
end
