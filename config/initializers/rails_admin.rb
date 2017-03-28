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

    config.include_models GalleryIndexPage, HomePage, Link, Article, ArticleCategory
    config.include_models PagesAbout, ContactPage, HomeSlide, HomeGalleryImage, HomeFirstAbout
    config.include_models HomeSecondAbout, User, Attachment, GalleryImage, GalleryAlbum, Tag, Tagging
    config.include_models MenuItem, Cms::MetaTags

    [Article, PublicationArticle, NewsArticle, AboutUsArticle, WhatWeDoArticle].each do |m|
      config.model m do
        navigation_label "Статті"
        edit do
          field :published
          field :featured
          field :article_category
          field :tags
          field :translations, :globalize_tabs
          field :image do
            help "Розмір аватарки: 400х300; Розмір для баннера на сторінці публікацій: великий: 800х400; малий: 360х180;вибрані новини на головній: 600х325;"
          end
          field :attachments
          field :release_date
          field :page_metadata
        end

        list do
          field :published
          field :name do
            label "І'мя"
            def value
              @bindings[:object].name
            end
          end
          field :article_category do
            label "Категорія"
          end
          field :image, :carrierwave do
            def value
              @bindings[:object].image.site_thumb.url
            end

            pretty_value do
              "<img src='#{value}'/>".html_safe
            end
          end
          field :release_date
        end
      end
    end
    config.model_translation Article do

      visible false

      edit do
        field :locale, :hidden
        field :name
        field :url_fragment
        field :description
        field :intro
        field :content, :ck_editor
        field :author
      end
    end

    config.model ArticleCategory do
      navigation_label "Статті"
      weight -100

      nestable_tree({
        position_field: :position
      })
      edit do
        field :published
        field :image do
          help "Що ми робимо: розмір баннера: 1200х396"
        end
        field :translations, :globalize_tabs
        field :page_metadata
        field :articles
      end
    end

    config.model_translation ArticleCategory do
      visible false
      edit do
        field :locale, :hidden
        field :name
        field :url_fragment do
          help "Наприклад, для статті 'Моя стаття': moya-stattia"
        end  
      end
    end

    config.model PagesAbout do
      navigation_label "Сторінки"
      edit do
        field :published
        field :translations, :globalize_tabs
      end
    end

    config.model_translation PagesAbout do
      visible false

      edit do
        field :locale, :hidden
        field :content, :ck_editor
      end
    end

    # home page elements
    config.model HomeSlide do
      weight -80
      navigation_label "Головна сторінка"

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
      visible false

      edit do
        field :locale, :hidden
        field :name
        field :image_alt
        field :description
        field :url
      end
    end

    config.model HomeFirstAbout do
      weight -1
      navigation_label "Головна сторінка"

      nestable_list true

      edit do
        field :published
        field :link
        field :translations, :globalize_tabs
      end


    end

    config.model_translation HomeFirstAbout do
      visible false

      edit do
        field :locale, :hidden
        #field :name
        field :description
      end
    end

    config.model HomeSecondAbout do
      navigation_label "Головна сторінка"

      nestable_list true

      edit do
        field :published
        field :link
        field :translations, :globalize_tabs
      end
    end

    config.model_translation HomeSecondAbout do
      visible false

      edit do
        field :locale, :hidden
        field :description
      end
    end

    config.model HomeGalleryImage do
      navigation_label "Головна сторінка"

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
      visible false

      edit do
        field :locale, :hidden
        field :image_alt
      end
    end

    # end home page

    config.model Attachment do
      nestable_list true

      edit do
        field :published
        field :position
        field :translations, :globalize_tabs
      end
    end

    config.model_translation Attachment do
      visible false

      edit do
        field :locale, :hidden
        field :name
        field :data
      end
    end

    config.model Tag do
      #nestable_list true
      
      navigation_label "Галерея"


      edit do
        field :translations, :globalize_tabs
        #field :taggables
      end
    end

    config.model_translation Tag do

      edit do
        field :locale, :hidden
        field :name
        field :url_fragment
      end
    end

    config.model Tagging do
      visible false
      edit do
        field :translations, :globalize_tabs
      end
    end

    config.model GalleryImage do
      navigation_label "Галерея"
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
          label "Thumbnail"
          def value
            @bindings[:object].translations.each do |t|
              attachment = t.send(name)
              if attachment.versions[:thumb].file.try(:exists?)
                return attachment
              end
            end

            return nil
            #@bindings[:object].get_data
          end

          # def resource_url
          #   v = value.versions[:thumb]
          #   return v.url if v.file.exists?
          #
          #   return nil
          # end



          
        end  
        field :name

        field :album
      end  
    end

    config.model_translation GalleryImage do
      visible false

      edit do
        field :locale, :hidden
        field :name
        field :data do
          label "Зображення"
          help "Розмір: 580х580"
        end
        field :alt
      end
    end

    config.model GalleryAlbum do

      navigation_label "Галерея"
      nestable_list true

      list do
        field :published
        field :name
        field :image do
          def value
            images = @bindings[:object].try(:images)
            if images
              images.first.image.url
            end
          end
        end

      end

      edit do
        field :tags
        field :published
        field :translations, :globalize_tabs
        field :page_metadata
        #field :images
      end
    end

    config.model_translation GalleryAlbum do
      visible false

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
        field :name do
          label "Ім'я"
        end
      end
    end

    config.model_translation MenuItem do
      visible false

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
        field :content do
          label "Ім'я"
        end
      end
    end

    config.model_translation Link do
      visible false

      edit do
        field :locale, :hidden
        field :content
        field :url
        field :alt
        field :title
      end
    end

    config.model ContactPage do
      weight -70
      navigation_label "Сторінки"

      edit do
        field :translations, :globalize_tabs
        field :page_metadata
      end
    end

    config.model_translation ContactPage do
      visible false
      edit do
        field :locale, :hidden
        field :url_fragment
      end
    end

    config.model Cms::MetaTags do
      edit do
        field :translations, :globalize_tabs
        group :advanced do
          field :template_name

        end
      end
    end

    config.model_translation Cms::MetaTags do
      visible false
      edit do
        field :locale, :hidden
        field :head_title
        field :meta_keywords
        field :meta_description
      end
    end

    config.model HomePage do
      navigation_label "Головна сторінка"
      label_plural "Метатеги для головної"
      weight -3
      edit do
        field :page_metadata
      end
    end

    config.model GalleryIndexPage do
      visible false
      weight -90
      navigation_label "Галерея"

      edit do
        field :page_metadata
      end
    end

    # =====================
    # about us
    # =====================
    config.include_models AboutPageContent
    config.include_models TeamMember, YearReport
    config.include_models PublicationArticle, NewsArticle, AboutUsArticle, WhatWeDoArticle

    config.model TeamMember do
      #navigation_label_key(:about_us, 1)
      field :image
      field :translations, :globalize_tabs
      field :emails
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

  end
end
