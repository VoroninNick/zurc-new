class CreateFooterCompaniesMarkups < ActiveRecord::Migration
  def change
    create_table :footer_companies_markups do |t|
      t.text :content

      t.timestamps null: false
    end
  end
end
