class AboutMapMarker < ActiveRecord::Base
  attr_accessible *attribute_names
  include Cms::TextFields

  globalize :title, :address

  boolean_scope :published

  def phones=(val)
    send(:line_separated_field=, :phones, val)
  end

  def phones(parse = true)
    line_separated_field(:phones, parse)
  end

  def emails=(val)
    send(:line_separated_field=, :emails, val)
  end

  def emails(parse = true)
    line_separated_field(:emails, parse)
  end

  def fax_phones=(val)
    send(:line_separated_field=, :fax_phones, val)
  end

  def fax_phones(parse = true)
    line_separated_field(:fax_phones, parse)
  end
end
