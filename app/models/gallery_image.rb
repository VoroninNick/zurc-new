class GalleryImage < ActiveRecord::Base

  attr_accessible *attribute_names

  # translations
  globalize :name, :alt#, :data

  def name
    (name = get_attr(:name)).present? ? name : data.try{|d| d.file.try(&:basename) }
  end

  mount_uploader :data, GalleryUploader

  TRANSLATE_IMAGE = false

  if TRANSLATE_IMAGE
    if defined?(Translation)
      Translation.class_eval do
        mount_uploader :data, GalleryUploader
      end
    end
  else
    mount_uploader :data, GalleryUploader
  end

  def image(version = :thumb)
    upload = data.send(version)
    upload = translations.select{|t| t.data.present?  }.first if TRANSLATE_IMAGE && upload.blank?

    upload
  end

  def image_url(version = :thumb)
    image(version).try{|t| t.url }
  end

  # associations

  has_tags

  # scopes
  boolean_scope :published
  scope :available, -> { published.joins(:translations).where.not(gallery_image_translations: { data: nil }) }

  if check_tables(:gallery_albums)
    belongs_to :album, class_name: GalleryAlbum
  end
  attr_accessible :album, :album_id

  # callbacks
  before_create :init_fields
  def init_fields
    self.published ||= true
  end

  def smart_to_param
    self.data.url
  end

  def get_props(image_field_name = "data", large_version_name = "gallery_image", thumb_version_name = "admin_thumb")
    img = self
    image_field = img.send(image_field_name); image_version = image_field.send(thumb_version_name); {id: img.id, name: image_version.url, url: image_version.url, large_image_url: image_field.send(large_version_name).url, size: image_field.file.size}
  end
end
