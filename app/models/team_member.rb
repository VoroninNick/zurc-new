class TeamMember < ActiveRecord::Base
  globalize :name, :position

  image :image, styles: {medium: "275x240#", thumb: "100x100#"}
end
