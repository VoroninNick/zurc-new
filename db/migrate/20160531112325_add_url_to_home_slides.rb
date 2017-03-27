class AddUrlToHomeSlides < ActiveRecord::Migration
  def change
    add_column :home_slides, :url, :string
    add_column HomeSlide::Translation.table_name, :url, :string
  end
end
