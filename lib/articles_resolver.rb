class ArticlesResolver < ::ActionView::FileSystemResolver
  attr_accessor :custom_folder
  def initialize(custom_articles_folder)
    super("app/views")
    @custom_folder = custom_articles_folder
  end

  def find_templates(name, prefix, partial, details)
    #super(name, "admin/defaults", partial, details)
    super(name, "publications", partial, details)
  end
end