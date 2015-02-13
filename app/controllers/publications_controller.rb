class PublicationsController < InnerPageController
  def index(articles = nil, featured_articles = nil, breadcrumbs_title = "Публікації")
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
      @breadcrumbs.push({title: "Публікації", url: send("publications_path"), current: false})
      @breadcrumbs.push({title: @article.name, url: false, current: true})
      all_publications = Article.published.publications
      current_index = nil
      all_publications.each_with_index {|item, index| if item.id == @article.id then; current_index = index; break; end; }
      @related_articles = all_publications[(current_index-1)..(current_index+1)].select{|p| p.id != @article.id }
      #@related_articles = @article.related_publications
    end
  end

  def news_index
    articles = Article.published.news.order_by_date_desc.page(params[:page]).per(100)
    index(articles, false, "Новини")
    respond_to do |format|
      format.html { render "index" }
    end
  end  

  def show_news
  end

  def about_index
    @articles = about_articles

    respond_to do |format|
      format.html do 
        @breadcrumbs.push({title: "Про нас", url: false, current: true})
      end
    end
  end

  def show_about
    @articles = about_articles
    @params_id = params[:id]
    @article = Article.with_translations.published.about_us.by_url(@params_id).first
    if @article
      @breadcrumbs.push({title: "Про нас", url: send("publications_path"), current: false})
      @breadcrumbs.push({title: @article.name, url: false, current: true})
    end

    render template: "publications/show_about"
  end

  private
  def about_articles
    Article.published.about_us.order_by_date_desc
  end

  
end