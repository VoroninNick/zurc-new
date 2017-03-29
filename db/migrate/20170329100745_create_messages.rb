class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.text :message_text

      t.string :referer
      t.string :session_id

      t.timestamps null: false
    end
  end
end
