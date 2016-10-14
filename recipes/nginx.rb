#
# Cookbook Name:: ice
# Recipe:: nginx
#

node.override['nginx']['default_site_enabled'] = false

include_recipe 'nginx::default'

# Configure nginx site reverse proxy
if node['ice']['public_hostname'].nil?
  node.override['ice']['public_hostname'] = if node.attribute?('ec2')
                                              node['ec2']['public_hostname']
                                            elsif node.attribute?('cloud')
                                              node['cloud']['public_hostname']
                                            else
                                              node['fqdn']
                                            end

  if node['ice']['nginx_port'] != 80
    node.override['ice']['public_hostname'] += ":#{node['ice']['nginx_port']}"
  end
end

# Disable default site first
nginx_site 'default' do
  enable false
  only_if node['ice']['nginx_disable_default_site']
end

# Generate nginx ice site
template "#{node['nginx']['dir']}/sites-available/ice" do
  cookbook node['ice']['nginx_config_cookbook']
  source node['ice']['nginx_config']
  mode 0644
  owner node['nginx']['user']
  group node['nginx']['group']
end

# Enable ice site
nginx_site 'ice'
