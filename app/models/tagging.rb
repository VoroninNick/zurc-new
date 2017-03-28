class Tagging < ActiveRecord::Base
  belongs_to :tag, class_name: Tag
  belongs_to :taggable, polymorphic: true, foreign_key: :taggable_id, foreign_type: :taggable_type

  attr_accessible :tag, :tag_id, :taggable, :taggable_id, :taggable_type
end
