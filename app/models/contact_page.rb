class ContactPage < ActiveRecord::Base
  # menu_items
  has_many :menu_items, as: :linkable
  attr_accessible :menu_items, :menu_item_ids
end
