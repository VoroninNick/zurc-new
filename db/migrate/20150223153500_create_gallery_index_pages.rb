class CreateGalleryIndexPages < ActiveRecord::Migration
  def change
    create_table :gallery_index_pages do |t|

      t.timestamps null: false
    end
  end
end
