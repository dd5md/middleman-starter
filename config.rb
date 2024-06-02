#-----------------------------------
# Extension-specific Configuration
#-----------------------------------

# Autoprefixer
activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

# Pretty URLs
activate :directory_indexes

# Localization
activate :i18n, :mount_at_root => :de

# Asset Helpers
activate :asset_hash

# Transpath Helpers
activate :transpath

#-----------------------------------
# Layout-specific Configuration
#-----------------------------------

page '/*.xml',      layout: false
page '/*.txt',      layout: false
page '/*.json',     layout: false
page 'sitemap.xml', layout: false

#-----------------------------------
# Helper-specific Configuration
#-----------------------------------

Dir['helpers/*.rb'].each {|file| require file }

helpers ApplicationHelper

Dir['helpers/*'].each(&method(:load))

#-----------------------------------
# Server-specific Configuration
#-----------------------------------

configure :server do
  # Debug Assets
  config[:debug_assets] = true
  # Port
  config[:port] = '7001'
  # Host
  config[:host] = 'http://localhost:7001'
  # Livereload
  activate :livereload, no_swf: true
end

#-----------------------------------
# Build-specific configuration
#-----------------------------------

configure :build do
  # Config Host
  config[:host] = 'https://dd5md.de'
  # Config URL_ROOT
  config[:url_root] = 'https://dd5md.de'
  # Minify CSS on Build
  activate :minify_css
  # Minify JS on Build
  activate :minify_javascript, compressor: Terser.new
  # Minify HTML on Build
  after_configuration do
    use ::HtmlCompressor::Rack,
      compress_css: true,
      compress_javascript: true,
      css_compressor: :yui,
      enabled: true,
      javascript_compressor: :yui,
      preserve_line_breaks: false,
      preserve_patterns: [],
      remove_comments: true,
      remove_form_attributes: false,
      remove_http_protocol: false,
      remove_https_protocol: false,
      remove_input_attributes: true,
      remove_intertag_spaces: true,
      remove_javascript_protocol: true,
      remove_link_attributes: true,
      remove_multi_spaces: true,
      remove_quotes: true,
      remove_script_attributes: true,
      remove_style_attributes: true,
      simple_boolean_attributes: true,
      simple_doctype: false
  end
  # Image Optim
  activate :imageoptim
  # Gzip
  activate :gzip
  # Critical CSS
  activate :critical, binary: '/usr/local/bin/critical'
  # SEO
  activate :sitemap, gzip: false, hostname: config[:host]
  # Robots
  activate :robots,
    :rules => [
      {user_agent: '*', allow: %w(/)}
    ],
    sitemap: config[:host] + '/sitemap.xml'
end
