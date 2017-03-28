class YearReport < ActiveRecord::Base
  attr_accessible *attribute_names

  globalize :name, :data

  if defined?(Translation)
    Translation.class_eval do
      mount_uploader :data, AttachmentUploader
    end
  end
end
