class CreateVersions < ActiveRecord::Migration
  def change
    create_versions = true
    add_object_changes_to_versions = true
    add_locale_to_versions = true


    # ============================================
    # --------------------------------------------
    # CreateVersions
    # --------------------------------------------
    # ============================================
    if create_versions
      create_table :versions do |t|
        t.string   :item_type, :null => false
        t.integer  :item_id,   :null => false
        t.string   :event,     :null => false
        t.string   :whodunnit
        t.text     :object
        t.datetime :created_at
      end
      add_index :versions, [:item_type, :item_id]
    end

    # ============================================
    # --------------------------------------------
    # AddObjectChangesToVersions
    # --------------------------------------------
    # ============================================
    if add_object_changes_to_versions
      add_column :versions, :object_changes, :text
    end

    # ============================================
    # --------------------------------------------
    # AddLocaleToVersions
    # --------------------------------------------
    # ============================================
    if add_locale_to_versions
      change_table :versions do |t|
        t.string :locale
      end
    end
  end
end