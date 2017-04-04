class ArticlesController < InnerPageController
  PER_PAGE = 15
  def index(articles = nil, featured_articles = nil, breadcrumbs_title = I18n.t("breadcrumbs.publications"))
    params_category = params[:article_category]
    respond_to do |format|

      @articles = articles || Article.published.send(params_category).unfeatured.order_by_date_desc.page(params[:page]).per(PER_PAGE)
      @featured_articles = featured_articles == false ? nil : featured_articles || Article.published.publications.featured 

      format.html do
        @breadcrumbs.push({title: breadcrumbs_title, url: false, current: true})
      end

      format.json do
        articles_html = ""
        @articles.each do |a|
          articles_html += render_to_string template: 'publication/_list_item.html', layout: false, locals: { articles: a }
        end
        data = { html: articles_html }
        render json: data
      end
    end

    # if params[:format] == "json"
    #   articles_html = render_to_string template: 'publication/_list_item', layout: false, collection: @articles
    #   data = { html: articles_html }
    #   #render inline: data.to_json
    #   render json: data
    # end
  end

  def show
    @params_id = params[:id]
    @article = Article.with_translations.published.publications.by_url(@params_id).first
    #render inline: @article.inspect

    if @article
      @breadcrumbs.push({title: I18n.t("breadcrumbs.publications"), url: send("publications_path"), current: false})
      if @article.name.present?
        @breadcrumbs.push({title: @article.name, url: false, current: true})
      end
      all_publications = Article.published.publications
      current_index = nil
      all_publications.each_with_index {|item, index| if item.id == @article.id then; current_index = index; break; end; }
      @related_articles = all_publications[(current_index-1)..(current_index+1)].select{|p| p.id != @article.id }
      #@related_articles = @article.related_publications
    end
  end

  def news_index
    articles = Article.published.news.order_by_date_desc.page(params[:page]).per(100)
    index(articles, false, I18n.t("breadcrumbs.news"))
    respond_to do |format|
      format.html { render "index" }
    end
  end  

  def show_news
    @params_id = params[:id]
    @article = Article.with_translations.published.news.by_url(@params_id).first

    if @article


      all_publications = Article.published.news
      current_index = nil
      all_publications.each_with_index {|item, index| if item.id == @article.id then; current_index = index; break; end; }
      @related_articles = all_publications[(current_index-1)..(current_index+1)].select{|p| p.id != @article.id }
      #@related_articles = @article.related_publications

      respond_to do |format|
        format.html do
          @breadcrumbs.push({title: I18n.t("breadcrumbs.publications"), url: send("publications_path"), current: false})


          if @article.name.present?
            @breadcrumbs.push({title: @article.name, url: false, current: true})
          end

          render template: "publications/show"
        end
      end
    end
  end

  def about_index

    @articles = about_articles

    respond_to do |format|
      format.html do
        @about_content = ((page = PagesAbout.published); page ? page.content : "" )
        @breadcrumbs.push({title: I18n.t("breadcrumbs.about-us"), url: false, current: true})
      end
    end
  end

  def show_about
    @articles = about_articles
    @params_id = params[:id]
    @article = Article.with_translations.published.about_us.by_url(@params_id).first
    if @article
      @breadcrumbs.push({title: I18n.t("breadcrumbs.about-us"), url: send("publications_path"), current: false})
      if @article.name.present?
        @breadcrumbs.push({title: @article.name, url: false, current: true})
      end
    end

    render template: "publications/show_about"
  end

  def what_we_do_category
    @article_categories = available_what_we_do_categories
    respond_to do |format|
      format.html do
        @breadcrumbs.push({title: I18n.t("breadcrumbs.what-we-do"), url: false, current: true})
      end
    end
  end

  def show_what_we_do_category
    @article_category = available_what_we_do_categories.select {|c| c.find_url_fragment_in_translations(url_fragment: params[:id]) }.first
    if @article_category
      @article_subcategories = @article_category.child_categories_with_articles.select{|c| c.published == true }
      #@articles = @article_category.articles

      respond_to do |format|
        format.html do
          @breadcrumbs.push({title: I18n.t("breadcrumbs.what-we-do"), url: send("what_we_do_path"), current: false})
          if @article_category.name.present?
            @breadcrumbs.push({title: @article_category.name, url: false, current: true})
          end

          @locale_links[another_locale.to_sym] = @article_category.smart_to_param

        end
      end
    end
  end

  def show_what_we_do_subcategory

  end

  def smart_article

    # first determine item is article or category

    root_category = ArticleCategory.with_translations.where(url_fragment: params[:root_category]).first

    if root_category
      #@tags = root_category.available_tags
      @root_category = root_category
      template_category = root_category.seo_tags.try(:template_name)
      template_category = nil
      template_category = "what_we_do" if root_category.what_we_do_category?
      template_category = "about_us" if root_category.about_us_category?

      template_name = "category"
      params_url = params[:url]

      resource = nil



      if params_url.present?
        category = root_category
        url_fragments_arr = params_url.split('/').select{|str| str.present? }
        last_url_fragment = url_fragments_arr.delete_at(url_fragments_arr.length - 1)
        #last_url_fragment = nil
        last_successful_index = 0
        url_fragments_arr_last_index = url_fragments_arr.length

        #render inline: "#{url_fragments_arr.inspect}" ; render_executed = true


        url_fragments_arr.each_with_index do |url_fragment, index|
          category_new = category.children.select{|c| c.available? && c.translations.where(url_fragment: url_fragment ).any? }.first
          break if category_new.nil?
          category = category_new
          last_successful_index = index
        end

        if last_successful_index == url_fragments_arr_last_index
          child_node = category.children.select{|c| c.available? && c.translations.where(url_fragment: last_url_fragment).any?  }.first
          if child_node.nil?
            child_node = category.articles.select{|a| a.available? && a.translations.where(url_fragment: last_url_fragment).any? }.first
          end

          if child_node.present?
            resource = child_node
          else
            render_not_found
          end

        else
          @category = category
        end
      else
        resource = root_category

        @category = root_category
        #articles_path = params_url
      end

      resource ||= root_category

      if resource.is_a?(Article)
        template_name = "item"
        @article = resource
      elsif resource.is_a?(ArticleCategory)
        template_name = "category"
        @category = resource
      end

      built_template_name = template_category.present? ? "#{template_category}_#{template_name}" : template_name

      @breadcrumbs = resource.smart_breadcrumbs
      I18n.available_locales.select{|locale| locale.to_sym != I18n.locale.to_sym }.each do |locale|
        @locale_links[locale.to_sym] = resource.smart_to_param
      end

      init_publication if  @article.try{|a| a.article_category.root.send(:publications_category?)}
      init_publications if @category.try{|c| c.root.send(:publications_category?)}
      init_news if @category.try{|c| c.root.send(:news_category?) }
      init_news_item if @article.try{|a| a.article_category.root.send(:news_category?)}
      init_about_us_category if @category.try{|c| c.root.send(:about_us_category?)}
      init_about_us_item if @article.try{|a| a.article_category.root.send(:about_us_category?)}
      init_what_we_do_category if @category.try{|c| c.root.send(:what_we_do_category?)}
      init_what_we_do_item if @article.try{|a| a.article_category.root.send(:what_we_do_category?)}

      @tags = root_category.available_tags
      selected_tags_str = params[:tags] || ""
      selected_tags_arr = selected_tags_str.split(",")
      @selected_tags = @tags.select{|tag| tag.url_fragment.in?(selected_tags_arr)}
      @selected_tag_ids = @selected_tags.map(&:id)





      if template_name.split('/').one?
        render built_template_name unless @render_executed
      else
        render template: built_template_name unless @render_executed
      end
      #render template: "#{template_name}" if resource.present?

    else
      render_not_found unless @render_executed
    end


  end

  def init_publications
    #@featured_articles = @category.available_articles.select{|a| a.featured? }.sort{|a, b| a.release_date.present? && b.release_date.present? ? a.release_date > b.release_date : (a.release_date.present? ? a : b )   }.first(3)
    @featured_articles = ArticleCategory.publications_category.articles.available.featured
    @all_articles = ArticleCategory.publications_category.articles.available.unfeatured
    init_tags_and_articles
  end

  def init_publication
    all_publications = Article.available.publications.order_by_date_desc
    current_index = nil
    all_publications.each_with_index {|item, index| if item.id == @article.id then; current_index = index; break; end; }
    @related_articles = all_publications[(current_index-1)..(current_index+1)].select{|p| p.id != @article.id }
  end

  def init_news
    #@featured_articles = @category.available_articles.select{|a| a.featured? }.sort{|a, b| a.release_date.present? && b.release_date.present? ? a.release_date > b.release_date : (a.release_date.present? ? a : b )   }.first(3)
    @all_articles = ArticleCategory.news_category.articles.available

    init_tags_and_articles


  end

  def init_tags_and_articles
    params_tags = (params[:tags] || "")
    params_tags_arr = params_tags.split(",")
    @articles = @all_articles
    @sort = params[:sort]
    @sort = :desc if @sort.blank? || !@sort.in?(["asc", "desc"])
    @sort = @sort.to_sym

    @articles = @articles.send("order_by_date_#{@sort}")

    if params_tags_arr.any?
      @articles = @articles.joins(tags: :translations).where(cms_tag_translations: {url_fragment: params_tags_arr, locale: I18n.locale}).uniq
    end
    @articles = @articles.page(params[:page]).per(PER_PAGE)
  end

  def init_news_item
    all_publications = ArticleCategory.news_category.articles.available.order_by_date_desc
    current_index = nil
    all_publications.each_with_index {|item, index| if item.id == @article.id then; current_index = index; break; end; }
    @related_articles = all_publications[(current_index-1)..(current_index+1)].select{|p| p.id != @article.id }
  end

  def init_about_us_category
    @articles = about_articles
    @about_content = ((page = PagesAbout.published); page ? page.content : "" )
  end

  def init_about_us_item
    @articles = about_articles
    #@params_id = params[:id]
    #@article = Article.with_translations.published.about_us.by_url(@params_id).first
  end

  def init_what_we_do_category
    #nvihev
    @subcategories = @category.available_child_categories
    @articles = @category.articles.available.order_by_date_desc
  end

  def init_what_we_do_item

  end




  def self.controller_path
    "articles"
  end

  def category

  end
  #
  # def smart_article
  #
  # end



  def available_what_we_do_categories
    ArticleCategory.available_what_we_do_categories
  end

  private
  def about_articles
    Article.published.about_us.order_by_date_desc
  end

  
end
