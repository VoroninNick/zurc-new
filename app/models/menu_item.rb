class MenuItem < ActiveRecord::Base
  attr_accessible :linkable_id, :linkable_type, :name, :link, :link_source, :name_source, :priority, :ancestry, :node_type, :items_source

  #enum link_source: [:custom_link, :association_name], name_source: [:custom_name, :association_slug]

  # associations
  belongs_to :linkable, polymorphic: true
  attr_accessible :linkable

  has_ancestry

  # translations
  globalize :name, :link



  def another_locale
    I18n.available_locales.map(&:to_sym).select {|locale| locale != I18n.locale.to_sym  }.first
  end

  def get_name
    #return "test"
    return get_attr(:name) if self.node_type.respond_to?(:to_sym) && self.node_type.to_sym == :menu  && self.get_attr(:name).present?
    return get_attr(:name) if self.name_source == "custom" && self.get_attr(:name).present?
    return linkable.get_name if self.linkable && self.linkable.respond_to?(:get_name) && self.linkable.get_name.present?

    return "#{self.class.to_s}##{self.id}"
  end

  def get_link
    return get_attr(:link) if self.link_source == "custom" && self.get_attr(:link).present?
    return linkable.to_param if self.linkable && self.linkable.to_param.present?
    return nil
  end

  # activerecord callbacks
  before_validation :init_fields
  def init_fields
    self.link_source = "association" unless self.link_source.in?(['custom', 'association'])
    self.name_source = "association" unless self.name_source.in?(['custom', 'association'])
    self.node_type = :menu_item unless self.node_type.to_sym.in? [:menu, :dynamic_menu_items_group, :menu_item ]
  end

  def menu_item_name

  end

  # checks
  def menu?
    #nodetype = self.node_type
    node_type.try(:to_sym) == :menu
  end

  def dynamic_menu_items_group?
    node_type.try(:to_sym) == :dynamic_menu_items_group
  end

  def menu_item?
    node_type.nil? ? true : node_type.to_sym == :menu_item
  end

  def self.main_menu
    MenuItem.where(id: 2).first
  end

  def compute_menu_item
    self_compute_menu_item(self)
  end

  def self.self_compute_menu_item(menu_item)

    if menu_item.dynamic_menu_items_group?
      items = menu_item.send("eval_#{menu_item.items_source}")
      #return Tree::TreeNode.new(menu_item.id.to_s)

    else
      #item = Tree::TreeNode.new

      item[:name] = menu_item.get_name
      item[:link] = menu_item.get_link
      if menu_item.children.any?
        menu_item.children.eac
      end
    end

  end

  def eval_about_children
    collection = ArticleCategory.about_us_category.try{|category| category.available? ? category.articles.select{|a| a.available? } : [] }
    if collection.any?
      return collection.map {|item| return { name: item.get_name, link: item.to_param } }
    end

    []
  end

  def eval_what_we_do_children
    collection = ArticleCategory.what_we_do_category.try{|category| category.available? ? category.children.select{|c| c.available? } : [] }
    if collection.any?
      return collection.map {|item| return { name: item.get_name, link: item.to_param } }
    end

    []
  end

end
