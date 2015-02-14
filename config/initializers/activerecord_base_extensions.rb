class ActiveRecord::Base
  def get_attr(attr_name, options = {} )

    options[:locales_priority] = [I18n.locale, another_locale] unless options.keys.include?(:locales_priority)
    options[:find_via] = [:globalize_accessors, :translations] unless options.keys.include?(:find_via)

    available_find_methods = [:globalize_accessors, :translations]


    object = self
    attr_value = nil

    return nil if !(object && object.respond_to?(:translations) && object.translations.any?)

    options[:find_via].each do |find_method|
      next unless available_find_methods.include?(find_method)

      if find_method == :globalize_accessors
        options[:locales_priority].select{|locale| locale.respond_to?(:to_sym) }.map(&:to_sym).each do |locale|
          next unless object.respond_to?(attr_name.to_sym)
          attr_value = object.send("#{attr_name}_#{I18n.locale}");
          break if attr_value.present?
        end
      elsif find_method == :translations
        options[:locales_priority].select{|locale| locale.respond_to?(:to_sym) }.map(&:to_sym).each do |locale|
          translation = object.translations_by_locale[locale]
          next unless translation.respond_to?(attr_name.to_sym)
          attr_value = translation.send("#{attr_name}");
          break if attr_value.present?
        end
      end

      break if attr_value.present?
    end

    attr_value
  end

  def another_locale
    I18n.available_locales.map(&:to_sym).select {|locale| locale != I18n.locale.to_sym  }.first
  end
end