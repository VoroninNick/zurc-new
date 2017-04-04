require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Zurc
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    #config.i18n.fallbacks = I18n::Locale::Fallbacks.new(uk: :en, en: :uk)
    config.i18n.fallbacks = true
    config.i18n.available_locales = [:uk, :en, :ru]
    config.i18n.default_locale = :uk



    Globalize.fallbacks = {en: [:uk], uk: [:en]}

    # Custom I18n fallbacks
    config.after_initialize do

    end

    # ===========================================================================
    # ---------------------------------------------------------------------------
    # assets precompile
    # ---------------------------------------------------------------------------
    # ===========================================================================

    config.assets.precompile = []
    config.assets.precompile += Ckeditor.assets
    config.assets.precompile += %w(zoomico.png jquery.js )

    config.assets.precompile += %w(ckeditor)
    config.assets.precompile += %w(rails_admin/rails_admin.css rails_admin/rails_admin.css)

    config.assets.precompile += %w(fonts/*, fontawesome*)

    config.assets.precompile += %w(rails_admin/colorpicker/*.gif rails_admin/colorpicker/*.png rails_admin/bootstrap/*.png rails_admin/aristo/images/* rails_admin/multiselect/*.png rails_admin/*.png)


    config.assets.precompile += %w(ckeditor/config.js)
    config.assets.precompile += %w(ckeditor/plugins/codemirror/plugin.js ckeditor/plugins/codemirror/lang/* ckeditor/plugins/codemirror/css/* ckeditor/plugins/codemirror/js/*.js ckeditor/plugins/codemirror/icons/* ckeditor/plugins/codemirror/theme/*)


    # add images
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)

    config.assets.precompile += %w(modernizr.custom.03421.js)

    config.assets.compile = true

    config.after_initialize do
      Disqus::defaults[:account] = "zurc-org"
      Disqus::defaults[:developer] = true
      Disqus::defaults[:container_id] = "disqus_thread"
      Disqus::defaults[:show_powered_by] = false
    end
  end
end
