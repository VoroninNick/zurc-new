class CreateAboutPageContents < ActiveRecord::Migration
  def up
    create_table :about_page_contents do |t|
      t.string :type
      t.string :content

      t.timestamps null: false
    end

    AboutPageContent.create_translation_table(:content)
  end

  def down
    AboutPageContent.drop_translation_table!

    drop_table :about_page_contents
  end
end
