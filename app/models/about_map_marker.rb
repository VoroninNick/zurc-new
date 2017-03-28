class AboutMapMarker < ActiveRecord::Base
  attr_accessible *attribute_names

  globalize :title, :address
end
