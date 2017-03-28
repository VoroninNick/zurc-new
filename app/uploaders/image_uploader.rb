# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    klass = model.class
    while klass.superclass && klass.superclass != ActiveRecord::Base
      klass = klass.superclass
    end
    "uploads/#{klass.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fit => [50, 50]
  end

  version :site_thumb do
    process :resize_to_fill => [180,180]
  end

  version :avatar do
    process :resize_to_fit => [400,300]
  end

  #with_options(if: proc { a = model.assetable; (a.is_a?(Article) && a.publication?) || ( a.is_a?(ArticleAd) && a.article.publication? )  })  do |publication_image|
  version :featured_article_large do
    process :resize_to_fill => [800, 400]
  end

  version :featured_article_small do
    process :resize_to_fill => [360, 180]
  end

  version :home_featured do
    process :resize_to_fill => [600, 325]
  end

  #end

  version :about_article_banner do
    process resize_to_fill: [800, 350]
  end



  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png svg)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end