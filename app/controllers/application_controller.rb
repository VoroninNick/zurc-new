class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def set_admin_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  # def url_options(options={})
  #   ({})
  #     .merge( {:locale => ( params[:locale] || I18n.locale)} )
  #     .merge(options)
  # end

  def redirect_to_admin
    path_for_redirect = "/#{I18n.locale}/#{ActiveAdmin.application.default_namespace}/#{params[:a]}#{"?"+request.query_string  if request.query_parameters.count > 0 }"
    #path_for_redirect = "/#{I18n.locale}/#{ActiveAdmin.application.default_namespace}/#{params[:a]}#{"?"+params.map { |key, value| "#{key}=#{value}" }.join('&')   }"
    #render inline: "#{params.map{|key, value| "#{key}=#{value}" }.join('&')}"
    redirect_to path_for_redirect
    #redirect_to url_for()
  end

  def user_for_paper_trail
    user_signed_in? ? current_user : 'Unknown user'
  end

  before_filter :set_locale

  def set_locale

    if params[:controller].scan(/\Arails_admin/).count == 0
      params_locale = params[:locale]
      locale = nil
      if params_locale && I18n.available_locales.include?(params_locale.to_sym)
        locale = params_locale
      else
        locale = I18n.default_locale
      end

      if locale.to_sym != I18n.locale.to_sym
        redirect_to locale: locale
      end
    end
  end

  before_filter :set_locale_links

  def set_locale_links
    @locale_links = {}
    I18n.available_locales.each do |locale|
      @locale_links[locale.to_sym] = url_for(locale: locale)
    end
  end

  def locale_priorities
    I18n.available_locales
  end

  def check_resource_locale2

  end



  def check_resource_locale(resource_class, *args )


    options = args.extract_options!
    defaults = {
        resource_translation_attribute: "#{resource_class.to_s.remove('::').underscore}_id",
        route_name: params[:route_name] || :one_item_articles,
        preferred_locale: I18n.locale,
        url_attribute_name: :url,
        url: params[:url],
        route_url_param_name: :url
    }
    defaults.each_pair do |key, value|
      if !options.keys.include?(key)
        options[key] = value
      end
    end

    resource_translation = resource_class.translation_class.where(:"#{options[:url_attribute_name]}" => options[:url], locale: options[:preferred_locale]).first

    need_redirect = false

    if resource_translation
      resource = resource_class.find(resource_translation.send(options[:resource_translation_attribute]))
      resource.translations.select{|t| I18n.available_locales.include?(t.locale) }.each do |t|
        @locale_links[t.locale.to_sym] = send("#{t.locale}_#{options[:route_name]}_path", url: t.send(options[:url_attribute_name]), locale: t.locale)
      end
    end
    translation_locale = options[:preferred_locale]

    required_locale = params[:locale]



    if resource_translation.nil?
      resource_translations = resource_class.translation_class.where(:"#{options[:url_attribute_name]}" => options[:url])
      if resource_translations.count > 0
        t = resource_translations.first
        resource = resource_class.find(t.send(options[:resource_translation_attribute]))
        translation_locale = t.locale.to_sym
        need_redirect = true

        future_locale = translation_locale
        if resource.translations_by_locale.keys.map(&:to_sym).include?(required_locale.to_sym)
          future_locale = required_locale
        end

        url_for_redirect = send("#{future_locale}_#{options[:route_name]}_path", :"#{options[:route_url_param_name]}" => resource.translations_by_locale[future_locale].send(options[:url_attribute_name]), locale: future_locale)
        redirect_to url_for_redirect, status: 302
      end
    end

    #return true # if redirect
    #return false # otherwise
    #return need_redirect
    return resource
  end

end


