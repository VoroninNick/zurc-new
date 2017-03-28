class HomeSecondAbout < ActiveRecord::Base
  attr_accessible :published, :name, :description, :position

  # link
  has_one :link, as: :owner, class_name: Link
  attr_accessible :link
  accepts_nested_attributes_for :link
  attr_accessible :link_attributes
  delegate :url, :content, to: :link

  # translations
  globalize :name, :description


  # scopes
  scope :published, proc { where(published: 't').ordered.limit(4) }
  scope :ordered, proc { order("position asc") }
end
