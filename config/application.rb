require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

if Rails.env.production?
 config_file = '/home/deploy/cypher/shared/config/settings.yml'
 if File.exists?(config_file)
   config = YAML.load(File.read(config_file))
   config.each do |key, value|
     ENV[key] ||= value.to_s unless value.kind_of? Hash
   end
 else
   raise 'Missing required configuration file /home/deploy/cypher/shared/config/settings.yml'
 end
end

module ConnectedApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths << Rails.root.join('constraints')
    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths += %W[#{config.root}/app/services]
  end
end
