require Rails.root.join "config/initializers/rake_settings"
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
    end

    config.included_models = []

    [Article, ArticleCategory, PagesAbout, HomeSlide, HomeGalleryImage, HomeFirstAbout, HomeSecondAbout, User].each do |model_class|
      config.included_models += [model_class]
      if model_class.respond_to?(:translates?) && model_class.translates?
        config.included_models += [model_class::Translation]
      end
    end

    config.model Article do
      navigation_label "Статті"
      edit do
        field :published
        field :featured
        field :article_category
        field :translations, :globalize_tabs
        field :image
        field :release_date



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
        field :image
        field :translations, :globalize_tabs
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
  end
end