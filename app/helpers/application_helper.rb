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
              return node.name +  nested_menu_nodes(sub_nodes)
            else
              return node.name
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
      h = {name: item.name, link: item.smart_to_param}
      next if h[:link].blank? || h[:name].blank?
      menu_items.push(h)
    end

    menu_items.push({name: I18n.t("gallery-page"), link: gallery_path(locale: I18n.locale)})

    separate_menu_items(menu_items)
  end

  def main_menu_what_we_do_items
    #waht_we_do_articles = Article.published.what_we_do.order_by_date_desc
    what_we_do_child_nodes = ArticleCategory.available_what_we_do_categories
    menu_items = []
    what_we_do_child_nodes.each do |item|
      h = {name: item.name, link: item.smart_to_param}
      next if h[:link].blank? || h[:name].blank?
      menu_items.push(h)
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

  def page_url(page)
    tags_str = @selected_tags.map(&:url_fragment).join(",")
    base_url = @root_category.url + sort_url_fragment + per_url_fragment
    if tags_str.present?
      base_url += "/tags=" + tags_str
    end

    base_url + page_url_fragment(page)

  end

  def page_url_fragment(page = @page, ignore_first_page = true)
    p = page.try(:to_i) || 1
    p > 1 ? "/page=" + p.to_s : ""
  end

  def tags_url_fragment(tag = :all)
    selected_tags_url_fragments = @selected_tags.map(&:url_fragment)
    if tag
      if !selected_tags_url_fragments.include?(tag.url_fragment)
        selected_tags_url_fragments << tag.url_fragment
      else
        selected_tags_url_fragments = selected_tags_url_fragments.select{|s| s != tag.url_fragment }
      end
    end
    tags_str = selected_tags_url_fragments.join(',')
    tags_str.present? ? "/tags=" + tags_str : ""
  end

  def tag_url(tag = :all)
    base_url = @root_category.url + sort_url_fragment + per_url_fragment
    if tag == :all
      return base_url
    end

    tags_part_str = tags_url_fragment(tag)

    base_url + tags_part_str
  end

  def sort_url_fragment(direction = @sort)
    "/sort=#{direction}"
  end

  def per_url_fragment(per = @per)
    "/per=#{per}"
  end

  def per_url(per = @per)
    tags_str = @selected_tags.map(&:url_fragment).join(",")
    base_url = @root_category.url + sort_url_fragment + per_url_fragment(per)
    if tags_str.present?
      base_url += "/tags=" + tags_str
    end

    base_url

  end

  def sort_url(direction)
    base_url = @root_category.url
    base_url + sort_url_fragment(direction) + per_url_fragment + tags_url_fragment(nil)
  end

  def sponsor_asset_path(image_name)
    asset_path("/sponsors/new/#{image_name}")
  end
end
