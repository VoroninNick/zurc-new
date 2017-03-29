class Message < ActiveRecord::Base
  attr_accessible *attribute_names

  validates_presence_of :name, :phone, :email, :message_text
  validates_length_of :name, minimum: 2, if: proc { self.name.present? }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, if: proc { self.email.present? }
  validates :phone, format: { with: /\A\+38 \([\d]{3}\) [\d]{3} [\d]{2} [\d]{2}\Z/ }, if: proc { self.phone.present? }

  def notify_admin
    MessageMailer.create_message(self).deliver
  end
end