module ApplicationHelper

  def main_menu_items
    menu_items = []
    ArticleCategory.available_roots.each do |category|
      sub_categories = category.children.select {|c| c.available? }
      menu_item = {}
      if sub_categories.any?
        sub_items = []
        sub_categories.each do |c|

        end
      end
    end
  end

  def nested_menu_nodes(nodes = nil )
    nodes = main_menu_items if nodes.nil?

    content_tag(:ul) do
      nodes.map do |node, sub_nodes|
        if node.available?
          content_tag(:li) do
            if sub_nodes
              return node.get_name +  nested_menu_nodes(sub_nodes)
            else
              return node.get_name
            end
          end
        end
      end.join.html_safe
    end
  end

  def main_menu_about_items
    about_articles = Article.published.about_us.order_by_date_desc
    menu_items = []
    about_articles.each do |item|
      menu_items.push({name: item.get_name, link: item.smart_to_param})
    end

    menu_items.push({name: I18n.t("gallery-page"), link: gallery_path(locale: I18n.locale)})

    separate_menu_items(menu_items)
  end

  def main_menu_what_we_do_items
    #waht_we_do_articles = Article.published.what_we_do.order_by_date_desc
    what_we_do_child_nodes = ArticleCategory.available_what_we_do_categories
    menu_items = []
    what_we_do_child_nodes.each do |item|
      menu_items.push({name: item.get_name, link: item.smart_to_param})
    end

    separate_menu_items(menu_items)
  end

  def separate_menu_items menu_items = []
    return [] if menu_items.empty?

    part1_length = (menu_items.length.to_f / 2).ceil
    part2_length = menu_items.length - part1_length

    if part1_length == 0
      return []
    end


    menu_items_part_1 = menu_items.first(part1_length)
    menu_items_part_2 = menu_items.last(part2_length)

    separated_menu_items = []
    separated_menu_items[0] = menu_items_part_1
    separated_menu_items[1] = menu_items_part_2 if menu_items_part_2.any?

    separated_menu_items
  end

  def render_main_menu

    content_tag(:ul) do

    end
  end

  def link_to_if_with_block condition, options, html_options={}, &block
    if condition
      link_to options, html_options, &block
    else
      capture &block
    end
  end

  def head_title
    title = @head_title
    title = @page_metadata.try{|m| m.get_head_title } if title.blank?
    title = I18n.t("head_title_untitled") if title.blank?
    I18n.t("head_title", title: title)
  end

  def meta_keywords
    keywords = @meta_keywords
    keywords = @page_metadata.try{|m| m.meta_keywords } if keywords.blank?
    keywords = "" if keywords.blank?
    keywords
  end

  def meta_description
    description = @meta_description
    description = @page_metadata.try{|m| m.meta_description } if description.blank?
    description = '' if description.blank?
    description
  end

  def seo_tags
    result = ""
    if (title = head_title).present?
      result += content_tag(:title, title)
    end

    if (description = meta_description).present?
      result += content_tag(:meta, nil, content: description, name: "description")
    end

    if (keywords = meta_keywords).present?
      result += content_tag(:meta, nil, name: "keywords", content: keywords)
    end

    result.html_safe
  end
end
