require 'serverspec'

# Required by serverspec
set :backend, :exec

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |file| require_relative(file) }

RSpec.configure do |config|
  config.before(:all) do
    config.path = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
  end
end
