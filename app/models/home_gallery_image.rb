class HomeGalleryImage < ActiveRecord::Base
  attr_accessible :published, :position, :image, :image_alt

  # translations
  globalize :image_alt

  def name
    self.image_alt
  end

  # images
  mount_uploader :image, HomeGalleryImageUploader

  # scopes
  scope :published, proc { where(published: 't').ordered.limit(20) }
  scope :ordered, proc { order("position asc") }
end
