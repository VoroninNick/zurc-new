class CreateYearReports < ActiveRecord::Migration
  def up
    create_table :year_reports do |t|
      t.boolean :published
      t.integer :sorting_position
      t.string :name
      t.string :data

      t.timestamps null: false
    end

    YearReport.create_translation_table(:name, :data)
  end

  def down
    YearReport.drop_translation_table!

    drop_table :year_reports
  end
end
