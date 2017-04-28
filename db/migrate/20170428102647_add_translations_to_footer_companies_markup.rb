class AddTranslationsToFooterCompaniesMarkup < ActiveRecord::Migration
  def change
    FooterCompaniesMarkup.create_translation_table(:content)
  end
end
