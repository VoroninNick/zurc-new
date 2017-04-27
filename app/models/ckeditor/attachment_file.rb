class CustomCkeditorAttachmentUploader < CkeditorAttachmentFileUploader
  def read_dimensions(*args, &block)
    extract_dimensions(*args, &block)
  end
end

class Ckeditor::AttachmentFile < Ckeditor::Asset
  mount_uploader :data, CustomCkeditorAttachmentUploader, :mount_on => :data_file_name

  def url_thumb
    @url_thumb ||= Ckeditor::Utils.filethumb(filename)
  end
end
