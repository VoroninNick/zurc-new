class HomeSlide < ActiveRecord::Base
  attr_accessible *attribute_names

  # translations
  globalize :name, :description, :image_alt, :url

  # images
  mount_uploader :image, HomeSlideUploader

  # scopes
  scope :published, proc { where(published: 't').ordered.limit(3) }
  scope :ordered, proc { order("position asc") }
end
