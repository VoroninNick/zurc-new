class TeamMember < ActiveRecord::Base
  attr_accessible *attribute_names

  include Cms::TextFields

  globalize :name, :position

  image :image, styles: {medium: "275x240#", thumb: "100x100#"}

  boolean_scope :published
  scope :order_by_sorting_position, -> { order("sorting_position asc") }

  default_scope do
    order_by_sorting_position
  end

  def emails=(val)
    send(:line_separated_field=, :emails, val)
  end

  def emails(parse = true)
    line_separated_field(:emails, parse)
  end
end
