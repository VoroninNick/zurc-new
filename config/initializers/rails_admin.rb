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
    config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

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

      multiple_upload
    end

    config.included_models = []
    if ActiveRecord::Base.check_tables(:gallery_images, :tags, :taggings, :gallery_albums)
      [Article, ArticleCategory, PagesAbout, ContactPage, HomeSlide, HomeGalleryImage, HomeFirstAbout, HomeSecondAbout, User, Attachment, GalleryImage, GalleryAlbum, Tag, Tagging, MenuItem, PageMetadata].each do |model_class|
        config.included_models += [model_class]
        if model_class.respond_to?(:translates?) && model_class.translates?
          config.included_models += [model_class::Translation]
        end
      end
    end

    config.model Article do
      navigation_label "Статті"
      edit do
        field :published
        field :featured
        field :article_category
        field :tags
        field :translations, :globalize_tabs
        field :image
        field :attachments
        field :release_date
        field :page_metadata
      end
    end

    config.model Article::Translation do
      visible false

      edit do
        field :locale, :hidden
        field :name
        field :slug
        field :description
        field :intro
        field :content, :ck_editor
        field :author
      end
    end

    config.model ArticleCategory do
      navigation_label "Статті"

      nestable_tree({
        position_field: :position
      })
      edit do
        field :published
        field :image
        field :translations, :globalize_tabs
        field :page_metadata
        field :articles
      end
    end

    config.model ArticleCategory::Translation do
      visible false
      edit do
        field :locale, :hidden
        field :name
        field :slug
      end
    end

    config.model PagesAbout do
      navigation_label "Сторінки"
      edit do
        field :published
        field :translations, :globalize_tabs
      end
    end

    config.model PagesAbout::Translation do
      visible false

      edit do
        field :locale, :hidden
        field :content, :ck_editor
      end
    end

    # home page elements
    config.model HomeSlide do
      navigation_label "Головна сторінка"

      nestable_list true

      edit do
        field :published
        field :image
        field :translations, :globalize_tabs
      end
    end

    config.model HomeSlide::Translation do
      visible false

      edit do
        field :locale, :hidden
        field :name
        field :image_alt
        field :description
      end
    end

    config.model HomeFirstAbout do
      navigation_label "Головна сторінка"

      nestable_list true

      edit do
        field :published
        field :translations, :globalize_tabs
      end
    end

    config.model HomeFirstAbout::Translation do
      visible false

      edit do
        field :locale, :hidden
        field :name
        field :description
      end
    end

    config.model HomeSecondAbout do
      navigation_label "Головна сторінка"

      nestable_list true

      edit do
        field :published
        field :translations, :globalize_tabs
      end
    end

    config.model HomeSecondAbout::Translation do
      visible false

      edit do
        field :locale, :hidden
        field :name
        field :description
      end
    end

    config.model HomeGalleryImage do
      navigation_label "Головна сторінка"

      nestable_list true

      edit do
        field :published
        field :image
        field :translations, :globalize_tabs
      end
    end

    config.model HomeGalleryImage::Translation do
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

    config.model Attachment::Translation do
      visible false

      edit do
        field :locale, :hidden
        field :name
        field :data
      end
    end

    config.model Tag do
      #nestable_list true

      edit do
        field :translations, :globalize_tabs
        #field :taggables
      end
    end

    config.model Tag::Translation do
      visible false

      edit do
        field :locale, :hidden
        field :name
        field :slug
      end
    end

    config.model Tagging do
      #nestable_list true
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
    end

    config.model GalleryImage::Translation do
      visible false

      edit do
        field :locale, :hidden
        field :name
        field :data
        field :alt
      end
    end

    config.model GalleryAlbum do
      navigation_label "Галерея"
      nestable_list true

      edit do
        field :tags
        field :published
        field :translations, :globalize_tabs
        field :page_metadata
      end
    end

    config.model GalleryAlbum::Translation do
      visible false

      edit do
        field :locale, :hidden
        field :name
        field :image
        field :alt
      end
    end

    config.model MenuItem do

      object_label_method do
        :get_name
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
        field :get_name do
          label "Ім'я"
        end
      end
    end

    config.model MenuItem::Translation do
      visible false

      edit do
        field :locale, :hidden
        field :name
        field :link
      end
    end

    config.model ContactPage do
      edit do
        field :translations, :globalize_tabs
        field :page_metadata
      end
    end

    config.model ContactPage::Translation do
      edit do
        field :locale, :hidden
        field :slug
      end
    end

    config.model PageMetadata do
      edit do
        field :translations, :globalize_tabs
        group :advanced do
          field :template_name

        end
      end
    end

    config.model PageMetadata::Translation do
      edit do
        field :locale, :hidden
        field :head_title
        field :meta_keywords
        field :meta_description
      end
    end

  end
end