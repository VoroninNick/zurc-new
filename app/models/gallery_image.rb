class GalleryImage < ActiveRecord::Base

  attr_accessible :name, :data, :published, :position, :alt

  # translations
  globalize :name, :alt, :data

  def name
    (name = get_attr(:name)).present? ? name : data.try{|d| d.file.try(&:basename) }
  end


  # associations

  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings

  attr_accessible :taggings, :tagging_ids, :tags, :tag_ids

  # scopes
  scope :published, -> { where(published: 't') }
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
