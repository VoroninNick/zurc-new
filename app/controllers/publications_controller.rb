class PublicationsController < InnerPageController
  def index(articles = nil, featured_articles = nil, breadcrumbs_title = I18n.t("breadcrumbs.publications"))
    params_category = params[:article_category]
    respond_to do |format|

      @articles = articles || Article.published.send(params_category).unfeatured.order_by_date_desc.page(params[:page]).per(100)
      @featured_articles = featured_articles == false ? nil : featured_articles || Article.published.publications.featured 

      format.html do
        @breadcrumbs.push({title: breadcrumbs_title, url: false, current: true})
      end

      format.json do
        articles_html = ""
        @articles.each do |a|
          articles_html += render_to_string template: 'publication/_list_item.html', layout: false, locals: { article: a }
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
      if @article.get_name.present?
        @breadcrumbs.push({title: @article.get_name, url: false, current: true})
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


          if @article.get_name.present?
            @breadcrumbs.push({title: @article.get_name, url: false, current: true})
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
        @about_content = ((page = PagesAbout.published); page ? page.get_content : "" )
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
      if @article.get_name.present?
        @breadcrumbs.push({title: @article.get_name, url: false, current: true})
      end
    end

    render template: "publications/show_about"
  end

  def what_we_do_index
    @article_categories = available_what_we_do_categories
    respond_to do |format|
      format.html do
        @breadcrumbs.push({title: I18n.t("breadcrumbs.what-we-do"), url: false, current: true})
      end
    end
  end

  def show_what_we_do_category
    @article_category = available_what_we_do_categories.select {|c| c.find_slug_in_translations(slug: params[:id]) }.first
    if @article_category
      @article_subcategories = @article_category.child_categories_with_articles.select{|c| c.published == true }
      #@articles = @article_category.articles

      respond_to do |format|
        format.html do
          @breadcrumbs.push({title: I18n.t("breadcrumbs.what-we-do"), url: send("publications_path"), current: false})
          if @article_category.get_name.present?
            @breadcrumbs.push({title: @article_category.get_name, url: false, current: true})
          end

          @locale_links[another_locale.to_sym] = @article_category.smart_to_param( locales_priority: [another_locale.to_sym, I18n.locale.to_sym])

        end
      end
    end
  end

  def show_what_we_do_subcategory

  end
  #
  # def smart_article
  #
  # end



  def available_what_we_do_categories
    ArticleCategory.published.what_we_do_category.child_categories_with_articles(find_in_descendants: true).select{|c| c.published == true }
  end

  private
  def about_articles
    Article.published.about_us.order_by_date_desc
  end

  
end
