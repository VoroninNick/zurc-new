class FooterCompaniesMarkup < ActiveRecord::Base
  attr_accessible *attribute_names

  globalize :content

  def self.content
    v = self.first.try(:content)
    v.present? ? v.html_safe : ""
  end
end
