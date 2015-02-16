class ContactPage < ActiveRecord::Base
  # menu_items
  has_many :menu_items, as: :linkable
  attr_accessible :menu_items, :menu_item_ids

  # page meta_data
  has_one :page_metadata, as: :page
  attr_accessible :page_metadata
end
