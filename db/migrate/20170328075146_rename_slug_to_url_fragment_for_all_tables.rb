class Renameurl_fragmentToUrlFragmentForAllTables < ActiveRecord::Migration
  def up
    Cms.tables.each do |table_name|
      if Cms.column_names(table_name).include?("url_fragment")
        rename_column table_name, "url_fragment", "url_fragment"
      end
    end
  end

  def down
    Cms.tables.each do |table_name|
      if Cms.column_names(table_name).include?("url_fragment")
        rename_column table_name, "url_fragment", "url_fragment"
      end
    end
  end
end
