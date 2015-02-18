class AddNodeTypeToMenuItems < ActiveRecord::Migration
  def change
    add_column :menu_items, :node_type, :string
  end
end
