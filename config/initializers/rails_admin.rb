require Rails.root.join "config/initializers/rake_settings"

require Rails.root.join("lib/rails_admin/multiple_upload.rb")

unless RakeSettings.self_skip_initializers?
  RailsAdmin.config do |config|

    ### Popular gems integration

    ## == Devise ==
    config.authenticate_with do
      warden.authenticate! scope: :user
    end
    config.current_user_method(&:current_user)

    ## == Cancan ==
    # config.authorize_with :cancan

    ## == PaperTrail ==
    #config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

    ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

    config.actions do
      dashboard                     # mandatory
      index                         # mandatory
      new
      export
      bulk_delete
      show
      edit
      delete
      show_in_app

      ## With an audit adapter, you can add:
      history_index
      history_show

      nestable

      multiple_upload do
        only GalleryAlbum
      end
    end


    config.navigation_labels do
      {articles: 0,
       about_us: 100,
       what_we_do: 200,
       gallery: 300,
       home: 400,
       pages: 500,
       attachments: 600,
       users: 700
      }
    end

    config.include_models GalleryIndexPage, HomePage, Link, Article, ArticleCategory
    config.include_models PagesAbout, ContactPage, HomeSlide, HomeGalleryImage, HomeFirstAbout
    config.include_models HomeSecondAbout, User, Attachment, GalleryImage, GalleryAlbum, Cms::Tag, Cms::Tagging
    config.include_models MenuItem, Cms::MetaTags
    config.include_models Message, FormConfigs::Message

    config.model FormConfigs::Message do
      field :email_receivers, :text do
      end
    end





    config.model User do
      navigation_label_key(:users, 1)
      list do
        field :id
        field :email
      end

      edit do
        field :email
        field :password
        field :password_confirmation
      end
    end

    [Article, PublicationArticle, NewsArticle, AboutUsArticle, WhatWeDoArticle].each_with_index do |m, i|
      config.model m do
        navigation_label_key :articles, i+1
        edit do
          field :published
          field :featured
          field :article_category do
            label do
              I18n.t("activerecord.attributes.article.article_category")
            end
            visible do
              klass = @bindings[:object].class
              klass == WhatWeDoArticle || klass == Article
            end
          end
          field :tags
          field :translations, :globalize_tabs
          field :image do
            help "Розмір аватарки: 400х300; Розмір для баннера на сторінці публікацій: великий: 800х400; малий: 360х180;вибрані новини на головній: 600х325;"
          end
          field :attachments
          field :release_date do
            date_format(:short)
          end
          field :seo_tags
        end

        list do
          field :published
          field :name do
            def value
              @bindings[:object].name
            end
          end
          field :article_category do
            label do
              I18n.t("activerecord.attributes.article.article_category")
            end
          end
          field :image, :carrierwave do
            def value
              @bindings[:object].image.site_thumb.url
            end

            pretty_value do
              "<img src='#{value}'/>".html_safe
            end
          end
          field :release_date do
            date_format(:short)
          end
        end
      end
    end
    config.model_translation Article do

      visible false

      edit do
        field :locale, :hidden
        field :name
        field :url_fragment
        field :page_url do
          read_only true

          def value
            locale = @bindings[:object].locale
            @bindings[:object].article.try(:url, locale)
          end

          pretty_value do
            value.present? ? "<a href='#{value}'>#{value}</a>".html_safe : "-"
          end
        end
        field :description
        field :intro
        field :content, :ck_editor
        field :author
      end
    end

    config.model ArticleCategory do
      navigation_label_key(:articles, 1)

      nestable_tree({
        position_field: :position
      })

      edit do
        field :published
        field :image do
          help "Що ми робимо: розмір баннера: 1200х396"
        end
        field :translations, :globalize_tabs
        field :seo_tags
        field :articles
      end
    end

    config.model_translation ArticleCategory do
      edit do
        field :locale, :hidden
        field :name
        field :url_fragment do
          help "Наприклад, для статті 'Моя стаття': moya-stattia"
        end  
      end
    end

    config.model PagesAbout do
      navigation_label_key(:pages, 2)
      edit do
        field :published
        field :translations, :globalize_tabs
      end
    end

    config.model_translation PagesAbout do

      edit do
        field :locale, :hidden
        field :content, :ck_editor
      end
    end

    # home page elements
    config.model HomeSlide do
      navigation_label_key :home, 1

      nestable_list true

      edit do
        field :published
        field :image do
          help "Розмір: 1800х800"
        end
        field :translations, :globalize_tabs
      end
    end

    config.model_translation HomeSlide do
      edit do
        field :locale, :hidden
        field :name
        field :image_alt
        field :description
        field :url
      end
    end

    config.model HomeFirstAbout do
      navigation_label_key(:home, 2)

      nestable_list true

      edit do
        field :published
        field :link
        field :translations, :globalize_tabs
      end


    end

    config.model_translation HomeFirstAbout do
      edit do
        field :locale, :hidden
        #field :name
        field :description
      end
    end

    config.model HomeSecondAbout do
      navigation_label_key(:home, 3)

      nestable_list true

      edit do
        field :published
        field :link
        field :translations, :globalize_tabs
      end
    end

    config.model_translation HomeSecondAbout do
      edit do
        field :locale, :hidden
        field :description
      end
    end

    config.model HomeGalleryImage do
      navigation_label_key(:home, 4)

      nestable_list true

      edit do
        field :published
        field :image do
          help "розмір: маленька: 175х100; велика: 700х400(зберігає пропорції)"
        end
        field :translations, :globalize_tabs
      end
    end

    config.model_translation HomeGalleryImage do
      edit do
        field :locale, :hidden
        field :image_alt
      end
    end

    # end home page

    config.model Attachment do
      navigation_label_key(:attachments, 1)
      nestable_list true

      edit do
        field :published
        field :position
        field :translations, :globalize_tabs
      end
    end

    config.model_translation Attachment do
      edit do
        field :locale, :hidden
        field :name
        field :data
      end
    end

    config.model Cms::Tag do
      #nestable_list true

      navigation_label_key(:gallery, 4)


      edit do
        field :translations, :globalize_tabs
        #field :taggables
      end
    end

    config.model_translation Cms::Tag do

      edit do
        field :locale, :hidden
        field :name
        field :url_fragment
      end
    end

    config.model Cms::Tagging do
      visible false
      edit do
        field :translations, :globalize_tabs
      end
    end

    config.model GalleryImage do
      navigation_label_key(:gallery, 3)
      nestable_list true

      edit do
        field :tags
        field :published
        field :translations, :globalize_tabs
      end

      list do
        field :published
        field :id
        field :data, :carrierwave do
          def value
            @bindings[:object].image_url
          end

          pretty_value do
            v = value
            if v.present?
              "<img src='#{v}'/>".html_safe
            else
              "-"
            end
          end




          
        end  
        field :name

        field :album
      end  
    end

    config.model_translation GalleryImage do
      edit do
        field :locale, :hidden
        field :name
        field :data do
          help "Розмір: 580х580"
        end
        field :alt
      end
    end

    config.model GalleryAlbum do

      navigation_label_key(:gallery, 2)
      nestable_list true

      list do
        field :published
        field :name do
          def value
            @bindings[:object].name
          end
        end
        field :image, :string do
          def value
            @bindings[:object].try(:image_url)
          end

          pretty_value do
            v = value
            if v.present?
              "<img src='#{v}'/>".html_safe
            else
              "-"
            end
          end
        end
        field :tags

      end

      edit do
        field :tags
        field :published
        field :translations, :globalize_tabs
        field :seo_tags
        #field :images
      end
    end

    config.model_translation GalleryAlbum do
      edit do
        field :locale, :hidden
        field :name
        field :url_fragment
        field :image
        field :alt
      end
    end

    config.model MenuItem do
      visible false
      object_label_method do
        :name
      end

      nestable_tree({
        position_field: :priority
      })

      edit do
        field :node_type, :enum do
          enum do
            [:menu, :dynamic_menu_items_group, :menu_item ]
          end
        end
        field :linkable
        field :link_source, :enum do
          enum do
            ['custom', 'association']
          end
        end
        field :name_source, :enum do
          enum do
            ['custom', 'association']
          end
        end

        group :for_dynamic_menu_items_group do
          field :items_source, :enum do
            enum do
              ['about_children', 'what_we_do_children']
            end
          end
        end

        field :translations, :globalize_tabs
      end

      list do
        field :name
      end
    end

    config.model_translation MenuItem do
      edit do
        field :locale, :hidden
        field :name
        field :link
      end
    end

    config.model Link do
      visible false
      object_label_method do
        :content
      end

      edit do
        field :owner
        field :linkable
        field :url_source, :enum do
          enum do
            ['custom', 'association']
          end
        end
        field :content_source, :enum do
          enum do
            ['custom', 'association']
          end
        end

        field :blank_window
        field :no_follow

        field :translations, :globalize_tabs
      end

      nested do
        field :owner do
          hide
        end
      end

      list do
        field :content
      end
    end

    config.model_translation Link do
      edit do
        field :locale, :hidden
        field :content
        field :url
        field :alt
        field :title
      end
    end

    config.model ContactPage do
      navigation_label_key(:pages, 1)

      edit do
        field :translations, :globalize_tabs
        field :seo_tags
      end
    end

    config.model_translation ContactPage do
      edit do
        field :locale, :hidden
        field :url_fragment
      end
    end

    config.model Cms::MetaTags do
      visible false
      edit do
        field :translations, :globalize_tabs
        group :advanced do
          field :template_name

        end
      end
    end

    config.model_translation Cms::MetaTags do
      edit do
        field :locale, :hidden
        field :title
        field :keywords
        field :description
      end
    end

    config.model HomePage do
      navigation_label_key(:home, 5)
      edit do
        field :seo_tags
      end
    end

    config.model GalleryIndexPage do
      visible false
      navigation_label_key(:gallery, 1)

      edit do
        field :seo_tags
      end
    end

    # =====================
    # about us
    # =====================
    #config.include_models AboutPageContent
    config.include_models TeamMember, AboutMapMarker
    config.include_models PublicationArticle, NewsArticle, AboutUsArticle, WhatWeDoArticle

    config.model TeamMember do
      navigation_label_key(:about_us, 1)
      list do
        field :published
        field :image
        field :translations, :globalize_tabs
        field :emails do
          def value
            @bindings[:object].emails.join(", ")
          end
        end
      end
      edit do
        field :published
        field :image
        field :translations, :globalize_tabs
        field :emails
      end
    end

    config.model_translation TeamMember do
      field :locale, :hidden
      field :name
      field :position
    end

    config.model AboutMission do
      #navigation_label_key :about_us, 2
      field :translations, :globalize_tabs
    end

    config.model_translation AboutMission do
      field :locale, :hidden
      field :content, :ck_editor
    end

    config.model YearReport do
      navigation_label_key(:about_us, 3)
      list do
        field :published
        field :name do
          def value
            @bindings[:object].name
          end
        end
        field :data, :carrierwave do
          def value
            @bindings[:object].data
          end
        end
      end
      edit do
        field :published
        field :translations, :globalize_tabs
      end
    end

    config.model_translation YearReport do
      field :locale, :hidden
      field :name
      field :data
    end

    config.model AboutMapMarker do
      navigation_label_key(:about_us, 4)
      list do
        field :published
        field :title
        field :address do
          def value
            @bindings[:object].address
          end
        end
        field :phones
        field :fax_phones
        field :emails
      end

      edit do

        field :published
        field :translations, :globalize_tabs
        field :phones
        field :fax_phones
        field :emails
        #field :lat_lng


        field :lat_lng, :map do
          longitude_field :lon
          google_api_key ENV["GOOGLE_MAPS_API_KEY"]
          # 49.842873,24.041152
          default_latitude 49.842873  # Sydney, Australia
          default_longitude 24.041152
          default_zoom_level 13
        end
      end
    end

    config.model_translation AboutMapMarker do
      field :locale, :hidden
      field :title
      field :address, :string
    end

    config.include_models Ckeditor::Picture
    config.model Ckeditor::Picture do
      visible false
    end

  end
end
