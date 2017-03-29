class GalleryImage < ActiveRecord::Base

  attr_accessible :name, :data, :published, :position, :alt

  # translations
  globalize :name, :alt#, :data

  def name
    (name = get_attr(:name)).present? ? name : data.try{|d| d.file.try(&:basename) }
  end

  mount_uploader :data, GalleryUploader

  if defined?(Translation)
    Translation.class_eval do
      mount_uploader :data, GalleryUploader
    end
  end

  def image_url(version = :thumb)
    url = data.send(version).url
    url = translations.select{|t| t.data.present?  }.first.try{|t| t.data.send(version).url } if url.blank?

    url
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
end
