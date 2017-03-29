class CreateCmsTables < ActiveRecord::Migration
  def up
    Cms.create_tables(only: [:form_configs, :pages, :sitemap_elements, :texts ])
  end

  def down
    Cms.drop_tables(only: [:form_configs, :pages, :sitemap_elements, :texts ])
  end
end
