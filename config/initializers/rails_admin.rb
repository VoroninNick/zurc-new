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

  [Article, ArticleCategory].each do |model_class|
    if model_class.respond_to?(:translates?) && model_class.translates?
      config.included_models += [model_class, model_class::Translation]
    end
  end

  config.model Article do
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
      field :content
      field :author
    end
  end

  config.model ArticleCategory do

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
end
