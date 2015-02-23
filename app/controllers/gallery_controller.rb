class GalleryController < ApplicationController
  before_action :init_gallery
  def init_gallery
    @articles = about_articles
  end

  def index

    #@available_tags = Tag.available.with_translations.pluck_to_hash("tag_translations.name", name: "tag_translations.slug")










    #@available_tags = Tag.available.with_translations.pluck_to_hash("tag_translations.name", name: "tag_translations.slug")

    #@available_tags = Tag.available.with_translations.pluck_to_hash(translations: [:name, :slug], taggings: :id )
    #User.where(id: foo.user_id).pluck(:name).first

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
    @gallery_album = GalleryAlbum.available.with_translations.where(slug: params_album).first
    if @gallery_album
      @breadcrumbs << { title: @gallery_album.get_name }
    end
    @gallery_images = @gallery_album.try{|a| a.images.available}
    @available_tags = Tag.available_for(@gallery_images)

    init_metadata
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
    @page_metadata = @gallery_album.try(&:page_metadata)

    if @page_metadata.try(&:get_head_title).blank?
      @head_title = @gallery_album.try(&:get_name)
    end

    @meta_keywords = @gallery_album.try{tags.map(&:get_name).select{|t| t.present? }.uniq.join(',')} if @page_metadata.try(&:get_meta_keywords).blank?

    @page_metadata = GalleryIndexPage.first.try(&:page_metadata) if @page_metadata.blank?




  end
end
