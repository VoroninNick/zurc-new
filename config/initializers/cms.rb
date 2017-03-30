Cms::CompressionConfig.initialize_compression(html_compress: false)
Cms::AssetsPrecompile.initialize_precompile

Sprockets::Manifest

Cms.config.provided_locales do
  [:uk, :en]
end