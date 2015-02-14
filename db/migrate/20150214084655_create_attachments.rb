class CreateAttachments < ActiveRecord::Migration
  def up
    create_table :attachments do |t|
      t.string :attachable_type
      t.integer :attachable_id
      t.string :name
      t.string :data
      t.boolean :published
      t.integer :position

      t.timestamps null: false
    end

    Attachment.create_translation_table!(data: :string, name: :string)
  end

  def down
    drop_table :attachments

    Attachment.drop_translation_table!
  end
end
