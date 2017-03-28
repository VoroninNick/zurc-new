class Addurl_fragmentToContactPage < ActiveRecord::Migration
  def up
    add_column :contact_pages, :url_fragment, :string

    ContactPage.create_translation_table(:url_fragment)
  end

  def down
    ContactPage.drop_translation_table!

    remove_column :contact_pages, :url_fragment
  end
end
