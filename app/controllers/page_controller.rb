class PageController < ApplicationController
  def index
    @home_slides = HomeSlide.published
    @home_first_abouts = HomeFirstAbout.published
    @home_second_abouts = HomeSecondAbout.published
    @home_gallery_images = HomeGalleryImage.published
    @featured_articles = Article.published.news.featured

    render layout: 'home'
  end

  def contact
  end

  def about
  end

  def what_we_do
    @breadcrumbs = [
        { title: 'ЩО МИ РОБИМО' }
    ]
  end

  def custom_page
    render inline: params.inspect
  end
end
