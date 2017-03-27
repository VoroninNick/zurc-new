class AddSlugToContactPage < ActiveRecord::Migration
  def up
    add_column :contact_pages, :slug, :string

    ContactPage.create_translation_table(:slug)
  end

  def down
    ContactPage.drop_translation_table!

    remove_column :contact_pages, :slug
  end
end
