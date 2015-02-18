class AddItemsSourceToMenuItems < ActiveRecord::Migration
  def change
    add_column :menu_items, :items_source, :string
  end
end
