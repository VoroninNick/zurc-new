module RailsAdmin
  module Config
    module Actions
      class MultipleUpload < Base
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'icon-upload'
          #'icon-question-sign'
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :controller do
          Proc.new do
            @response = {}

            album_class = ::GalleryAlbum
            underscored_album_class_name = "gallery_album"
            underscored_album_id = "gallery_album_id"
            album_images_association_name = "images"
            album_images_attributes_field_name = "images_attributes"
            image_field_name = "data"


            if request.post?
              object = album_class.find_by_id(params[underscored_album_id.to_sym])
              if object
                #@album.update_attribute(:images_attributes, params[:album][:images_attributes])
                params[underscored_album_class_name.to_sym][album_images_attributes_field_name.to_sym].each do |params_element|
                  image = object.send(album_images_association_name).build
                  #image.data = params_element[:file]

                  [I18n.locale].each do |locale|
                    image_translation = image.translations.any? ? image.translations_by_locale[locale] : nil
                    if image_translation.nil?
                      image_translation = image.translations.build(locale: locale)
                    end

                    image_translation.send("#{image_field_name}=", params_element[:file] ) #if I18n.locale.to_sym == locale.to_sym

                    #image.save
                  end
                end

                object.save
              end
            end

            render :action => @action.template_name
          end
        end
      end
    end
  end
end