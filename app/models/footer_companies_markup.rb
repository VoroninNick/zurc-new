class FooterCompaniesMarkup < ActiveRecord::Base
  attr_accessible *attribute_names

  def self.content
    self.first.try(:content).stringify.html_safe
  end
end
