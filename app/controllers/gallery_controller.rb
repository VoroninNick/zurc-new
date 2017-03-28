class GalleryController < ApplicationController
  before_action :init_gallery
  def init_gallery
    @articles = about_articles
  end

  def index

  end

  def albums

    @gallery_albums = GalleryAlbum.available
    @available_tags = Tag.available_for(@gallery_albums)

    gallery_breadcrumbs

    init_metadata
  end

  def images
    gallery_breadcrumbs

    params_album = params[:album]
    @gallery_album = GalleryAlbum.available.with_translations.where(url_fragment: params_album).first
    if @gallery_album
      @breadcrumbs << { title: @gallery_album.name }
    end
    @gallery_images = @gallery_album.try{|a| a.images.available}
    @available_tags = Tag.available_for(@gallery_images)

    init_metadata
  end

  def order_gallery_album_images
    order_data = params[:order_data]

    order_array_data = order_data.map{ |key, value| value }
    render inline: order_array_data.inspect
    ids = order_array_data.map{|item| item[:id].to_i }
    images = GalleryImage.where(id: ids)
    images.each_with_index do |image, index|
      image_order_data = order_array_data.select{|item| item[:id].to_i == image.id }.first
      data_position = image_order_data[:position].to_i
      if data_position != image.position
        image.position = data_position
        image.save
      end
    end
  end

  def delete_gallery_image
    image_id = params[:image_id].to_i
    GalleryImage.destroy(image_id)
  end

  private

  def gallery_breadcrumbs
    @breadcrumbs = []
    @breadcrumbs << { title: I18n.t("breadcrumbs.about-us"), url: ArticleCategory.about_us_category.smart_to_param }
    @breadcrumbs << { title: I18n.t("breadcrumbs.gallery"), url: gallery_path(locale: I18n.locale) }
  end


  def about_articles
    Article.published.about_us.order_by_date_desc
  end

  def init_metadata

  end


end
