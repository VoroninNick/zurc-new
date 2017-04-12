class MessageMailer < ApplicationMailer
  def receivers(name)
    config_class = "FormConfigs::#{name.classify}".constantize
    to = config_class.first.try(&:emails) || config_class.default_emails
    to
  end

  def create_message message = nil
    init_host
    set_admin_root
    @message = message
    mail(template_path: 'mailers/message', template_name: 'create_message', from: 'support@voroninstudio.eu', to: receivers(:message))
  end

  def init_host
    @host = (ENV["#{Rails.env}.host_with_port"] || ENV["#{Rails.env}.host"])
  end

  def set_admin_root
    @admin_root = @host + "/admin"
  end
end
