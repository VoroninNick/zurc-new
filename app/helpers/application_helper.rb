module ApplicationHelper


  def main_menu_about_items
    about_articles = Article.published.about_us.order_by_date_desc
    menu_items = []
    about_articles.each do |item|
      menu_items.push({name: item.get_name, link: item.to_param})
    end

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
end
