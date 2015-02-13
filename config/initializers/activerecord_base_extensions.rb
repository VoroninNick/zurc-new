class ActiveRecord::Base
  def get_attr(attr_name, locales_priority = [I18n.locale, another_locale] )

    object = self
    attr_value = nil

    return nil if !(object && object.respond_to?(:translations) && object.translations.any?)

    locales_priority.select{|locale| locale.respond_to?(:to_sym) }.map(&:to_sym).each do |locale|
      next unless object.respond_to?(attr_name.to_sym)
      attr_value = object.send("#{attr_name}_#{I18n.locale}");
      break if attr_value.present?
    end

    attr_value
  end

  def another_locale
    I18n.available_locales.map(&:to_sym).select {|locale| locale != I18n.locale.to_sym  }.first
  end
end