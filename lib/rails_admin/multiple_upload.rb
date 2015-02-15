module RailsAdmin
  module Config
    module Actions
      class MultipleUpload < Base
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          #'icon-upload'
          'icon-question-sign'
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :controller do
          Proc.new do
            @response = {}

            if request.post?
              @album = ::GalleryAlbum.find_by_id(params[:album_id])
              #@album.update_attribute(:images_attributes, params[:album][:images_attributes])
              params[:album][:images_attributes].each do |params_element|
                image = @album.images.build
                #image.data = params_element[:file]
                I18n.available_locales.each do |locale|
                  translation = image.translations.build(locale: locale)
                  translation.data = params_element[:file] if I18n.locale.to_sym == locale.to_sym

                end
              end

              @album.save
            end

            render :action => @action.template_name
          end
        end
      end
    end
  end
end