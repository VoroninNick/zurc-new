class Message
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :phone, :email, :message_text

  def initialize message = nil
    if message && message.is_a?(Hash)
      message.each_pair do |key, value|
        send("#{key}=", value)
      end
    end

  end

  validates_presence_of :name, :phone, :email, :message_text
  validates_length_of :name, minimum: 2, if: proc { self.name.present? }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, if: proc { self.email.present? }
  validates :phone, format: { with: /\A\+38 \([\d]{3}\) [\d]{3} [\d]{2} [\d]{2}\Z/ }, if: proc { self.phone.present? }


  def persisted?
    false
  end
end