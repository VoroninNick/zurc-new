class Attachment < ActiveRecord::Base
  attr_accessible :attachable_type, :attachable_id, :name, :data, :published, :position


  # translations
  globalize :name, :data#, versioning: :paper_trail#, fallbacks_for_empty_translations: true

  if defined?(Translation)
    Translation.class_eval do
      mount_uploader :data, AttachmentUploader
    end
  end


  def get_attr(attr_name, options = {} )
    options[:locales_priority] = [I18n.locale, another_locale] unless options.keys.include?(:locales_priority)
    super(attr_name, options)
  end

  def another_locale
    I18n.available_locales.map(&:to_sym).select {|locale| locale != I18n.locale.to_sym  }.first
  end

  def icon_url
    data = self.data
    if data.present?
      #allowed_extensions = ["pdf"]
      extension_image_names = {
          pdf: "pdf.png",
          doc: "doc.png",
          docx: "doc.png",
          default: "basic_document_icon.png"
      }
      ext_name = File.extname(data.file.path)
      ext_name_without_dot = ext_name[1, ext_name.length]
      icon_file_name = extension_image_names[ext_name_without_dot.to_sym]
      icon_file_name = extension_image_names[:default] if icon_file_name.blank?

      return "/assets/file_icons/#{icon_file_name}"
    else
      return nil
    end
  end

  def data
    self.get_attr(:data)
  end

  # associations
  belongs_to :attachable, polymorphic: true
  attr_accessible :attachable

  # scopes
  scope :published, proc { where(published: 't').ordered.limit(4) }
  scope :ordered, proc { order("position asc") }
end
