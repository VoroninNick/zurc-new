class VoroninStudio::DynamicRouter
  def self.load_example
    Rails.application.class.routes.draw do
      Page.all.each do |page|
        #puts "Routing #{pg.name}"
        to = 'pages#show'
        if (page.controller && page.controller.length > 0) && (page.action && page.action.length > 0)
          to = "#{page.controller}##{page.action}"
        end

        page.translations_by_locale.keys.each do |locale|
          I18n.with_locale locale do
            get page.path, :to => to, defaults: { page_id: page.id, locale: locale }
          end
        end

      end
    end

    #if Configuration.settings_hash["detect_locale_automatically"] == 'true'

    #end
  end

  def self.load

    route_model = VoroninStudio::Route
    if route_model.table_exists?
      Rails.application.class.routes.draw do
        route_model.all.each do |route|
          rb_code = "def #{route.route_name}_path( options = {})" +'options[:locale] = I18n.locale if !options.include? :locale; '+'send( "#{I18n.locale}_' + "#{route.route_name}_path" +'", options ); end'

          Rails.application.routes.url_helpers.module_eval rb_code
          #ApplicationHelper.module_eval rb_code

          route.translations_by_locale.each_pair do |locale, route_translation|
            to = route.controller_action

            if !to || (to.respond_to?(:length) && to.length == 0) || !to.match(/^\w{1,}#\w{1,}$/)
              to = redirect(route_translation.redirect_to_url)
            end

            match "(/:locale)#{route_translation.route_string}", to: to, as: "#{locale}_#{route.route_name}", via: route.method_list, constraints: { locale: /[a-zA-Z]{2,2}/ }, defaults: { predefined_locale: locale.to_s, route_id: route.id, route_locale: locale.to_s }
          end
        end
      end
    end
  end

  #def self.load_root_categories

    #route_model = VoroninStudio::Route
    #if route_model.table_exists?
    # Rails.application.class.routes.draw do
    #   ArticleCategory.roots.published.each do |route|
    #     rb_code = "def #{route.route_name}_path( options = {})" +'options[:locale] = I18n.locale if !options.include? :locale; '+'send( "#{I18n.locale}_' + "#{route.route_name}_path" +'", options ); end'
    #
    #     Rails.application.routes.url_helpers.module_eval rb_code
    #     #ApplicationHelper.module_eval rb_code
    #
    #     route.translations_by_locale.each_pair do |locale, route_translation|
    #       to = route.controller_action
    #
    #       if !to || (to.respond_to?(:length) && to.length == 0) || !to.match(/^\w{1,}#\w{1,}$/)
    #         to = redirect(route_translation.redirect_to_url)
    #       end
    #
    #       match "(/:locale)#{route_translation.route_string}", to: to, as: "#{locale}_#{route.route_name}", via: route.method_list, constraints: { locale: /[a-zA-Z]{2,2}/ }, defaults: { predefined_locale: locale.to_s, route_id: route.id, route_locale: locale.to_s }
    #     end
    #   end
    # end
    #end
  #end

  def self.load_root_categories
    #categories = ArticleCategory.roots.published
    #translations = categories.map(&:translations)
    #slugs = translations.map(&:slug).select{ |s| s.present? }
    #get "/:root_category/(*url)", to: "publications#category", as: :smart_publication, root_category: /#{slugs.join('|')}/

    get "/:root_category/(*url)", to: "publications#category", as: :smart_article, root_category: /#{ArticleCategory.roots.published.map(&:translations).map(&:slug).select{|s| s.present? }.join('|')}/
  end

  def self.reload
    Rails.application.class.routes_reloader.reload!
  end
end