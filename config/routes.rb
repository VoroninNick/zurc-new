require Rails.root.join "config/initializers/rake_settings"

unless RakeSettings.self_skip_initializers?
  Rails.application.routes.draw do

    post "update_images_order", to: "gallery#order_gallery_album_images"
    post "delete_gallery_image", to: "gallery#delete_gallery_image"

    scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
      get "/gallery", to: "gallery#albums", as: :gallery
      get "/gallery/:album", to: "gallery#images", as: :gallery_album

      mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
      mount Ckeditor::Engine => '/ckeditor'
      devise_for :users

      if ArticleCategory.table_exists?
        get "/:root_category/(*url)", to: "articles#smart_article", as: :smart_article, root_category: /#{ arr = ArticleCategory.roots.published.map(&:translations); translations = []; arr.each {|sub_arr| translations.concat sub_arr };   translations.map(&:url_fragment).select{|s| s.present? }.uniq.join('|')}/
      end
      if ContactPage.table_exists?
        contact_url_fragments = ( arr = ContactPage.all.map(&:translations); translations = []; arr.each {|sub_arr| translations.concat sub_arr };   translations.map(&:url_fragment).select{|s| s.present? }.uniq.join('|'))
        get "/*url", to: "contact#index", as: :contact, url: /#{contact_url_fragments}/ if contact_url_fragments.present?
      end
      match "/:model_name/:id/multiple_upload", to: 'rails_admin/main#multiple_upload', as: :ra_multiple_upload, via: [:get, :post]
      #
      match '/message', to: 'contact#message', via: [:get, :post], as: :message
      root to: 'page#index'
      #get 'contact', to: 'contact#index', as: :contact

      #get "news/list", to: 'news#list', as: :news_list
      #get "news/:id", to: 'publications#show_news', as: :news_view
      #get "publications", to: 'publications#index', as: :publications, defaults: { article_category: :publications }
      #get "publications/:id", to: 'publications#show', as: :show_publication, defaults: { article_category: :publications }
      #get "news", to: 'publications#news_index', as: :news, defaults: { article_category: :news }
      #get "news/:id", to: 'publications#show_news', as: :show_news, defaults: { article_category: :news }

      #get "contact", to:'contact', as: 'contact'
      #get "about", to: 'publications#about_index', as: :about, defaults: { article_category: :about }
      #get "about/:id", to: 'publications#show_about', as: :show_about, defaults: { article_category: :about }

      #get "what-we-do", to: 'publications#what_we_do_index', as: :what_we_do
      #get "what-we-do/:id", to: 'publications#show_what_we_do_category', as: :show_what_we_do_category
      #get "what-we-do/:category_id/:sub_category_id", to: "publications#show_what_we_do_subcategory", as: :show_what_we_do_subcategory
      #get "/what-we-do/*url", to: "publications#smart_article", as: :smart_article


      #DynamicRouter.load_root_categories

    end




    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".

    # You can have the root of your site routed with "root"
    # root 'welcome#index'

    # Example of regular route:
    #   get 'products/:id' => 'catalog#view'

    # Example of named route that can be invoked with purchase_url(id: product.id)
    #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

    # Example resource route (maps HTTP verbs to controller actions automatically):
    #   resources :products

    # Example resource route with options:
    #   resources :products do
    #     member do
    #       get 'short'
    #       post 'toggle'
    #     end
    #
    #     collection do
    #       get 'sold'
    #     end
    #   end

    # Example resource route with sub-resources:
    #   resources :products do
    #     resources :comments, :sales
    #     resource :seller
    #   end

    # Example resource route with more complex sub-resources:
    #   resources :products do
    #     resources :comments
    #     resources :sales do
    #       get 'recent', on: :collection
    #     end
    #   end

    # Example resource route with concerns:
    #   concern :toggleable do
    #     post 'toggle'
    #   end
    #   resources :posts, concerns: :toggleable
    #   resources :photos, concerns: :toggleable

    # Example resource route within a namespace:
    #   namespace :admin do
    #     # Directs /admin/products/* to Admin::ProductsController
    #     # (app/controllers/admin/products_controller.rb)
    #     resources :products
    #   end
  end
end