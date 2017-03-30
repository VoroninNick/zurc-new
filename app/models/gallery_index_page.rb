class GalleryIndexPage < ActiveRecord::Base
  attr_accessible *attribute_names

  has_seo_tags
end
