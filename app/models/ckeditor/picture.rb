class CustomCkeditorPictureUploader < CkeditorPictureUploader
  def read_dimensions(*args, &block)
    extract_dimensions(*args, &block)
  end
end

class Ckeditor::Picture < Ckeditor::Asset
  mount_uploader :data, CustomCkeditorPictureUploader, :mount_on => :data_file_name

  def url_content
    url(:content)
  end
end
