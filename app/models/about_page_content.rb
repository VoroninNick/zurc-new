class AboutPageContent < ActiveRecord::Base
  attr_accessible *attribute_names

  globalize :content

  has_seo_tags
end
