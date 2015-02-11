class PublicationsController < InnerPageController
  def index

    respond_to do |format|

      @articles = Article.published.publications.unfeatured.page(params[:page]).per(100)
      @featured_articles = Article.published.publications.featured

      format.html do


        @breadcrumbs.push({title: "Публікації", url: false, current: true})



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
end
