class MessageMailer < ApplicationMailer
  def create_message message = nil
    #if message.is_a?(Message) && message.valid?
      @message = message
      mail(template_path: 'mailers/message', template_name: 'create_message', from: 'support@voroninstudio.eu', to: 'p.korenev@voroninstudio.eu')
    #end
  end
end
