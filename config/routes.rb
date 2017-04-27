require Rails.root.join "config/initializers/rake_settings"

unless RakeSettings.self_skip_initializers?
  Rails.application.routes.draw do
    mount Ckeditor::Engine => '/ckeditor'
    post "message", to: "contact#post_message", as: :send_message
    get '/message', to: 'contact#message', as: :message

    post "update_images_order", to: "gallery#order_gallery_album_images"
    post "delete_gallery_image", to: "gallery#delete_gallery_image"

    scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
      get "/gallery", to: "gallery#albums", as: :gallery
      get "/gallery/:album", to: "gallery#images", as: :gallery_album

      mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

      devise_for :users

      if ArticleCategory.table_exists?
        get "/:root_category(/sort=:sort)(/per=:per)(/tags=:tags)(/page=:page)/(*url)", to: "articles#smart_article", as: :smart_article, root_category: /#{ arr = ArticleCategory.roots.published.map(&:translations); translations = []; arr.each {|sub_arr| translations.concat sub_arr };   translations.map(&:url_fragment).select{|s| s.present? }.uniq.join('|')}/
      end
      if ContactPage.table_exists?
        contact_url_fragments = ( arr = ContactPage.all.map(&:translations); translations = []; arr.each {|sub_arr| translations.concat sub_arr };   translations.map(&:url_fragment).select{|s| s.present? }.uniq.join('|'))
        get "/*url", to: "contact#index", as: :contact, url: /#{contact_url_fragments}/ if contact_url_fragments.present?
      end
      match "/:model_name/:id/multiple_upload", to: 'rails_admin/main#multiple_upload', as: :ra_multiple_upload, via: [:get, :post]
      #

      root to: 'page#index'


    end




  end
end