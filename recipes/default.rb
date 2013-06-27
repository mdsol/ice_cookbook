#
# Cookbook Name:: ice
# Recipe:: default
#
# Copyright 2013 Medidata Solutions Worldwide 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if node['platform_family'] == 'debian'
  include_recipe 'apt'
end

include_recipe 'java'
include_recipe 'tomcat'

java_options = "#{node['tomcat']['java_options']} -Dice.s3AccessKeyId=#{node['ice']['billing_aws_access_key_id']} -Dice.s3SecretKey=#{node['ice']['billing_aws_secret_key']}"

node.override['tomcat']['java_options'] = java_options
node.override['nginx']['default_site_enabled'] = false

artifact_deploy 'ice' do
  version node['ice']['version']
  artifact_location "#{node['ice']['war_url']}/ice-#{node['ice']['version']}.war"
  artifact_checksum node['ice']['checksum']
  deploy_to node['tomcat']['webapp_dir']
  owner node['tomcat']['user']
  group node['tomcat']['group']
  skip_manifest_check true
  keep 2
  should_migrate false
  force (node['ice']['force_deploy'] ? true : false)
  action :deploy

  before_deploy Proc.new {
    # Create ice local procesor work directory
    directory node['ice']['processor']['local_dir'] do
        owner node['tomcat']['user']
        group node['tomcat']['group']
        mode '0755'
      only_if { node['ice']['processor']['enabled'] == true }
    end

    # Create ice local reader work directory
    directory node['ice']['reader']['local_dir'] do
        owner node['tomcat']['user']
        group node['tomcat']['group']
        mode '0755'
        only_if { node['ice']['reader']['enabled'] == true }
    end
  }

  configure Proc.new {
    # Create ice.properties file
    template "#{release_path}/WEB-INF/classes/ice.properties" do
      source 'ice.properties.erb'
      owner node['tomcat']['user']
      group node['tomcat']['group']
      mode '0644'
    end
  }

  restart Proc.new {
    service 'tomcat6' do
      action :restart
    end
  }
end

if node['ice']['reader']['enabled'] == true
  include_recipe 'nginx'

  # Configure nginx site reverse proxy
  if node['ice']['public_hostname'].nil?
    if node.attribute?('ec2')
      node.override['ice']['public_hostname'] = node['ec2']['public_hostname']
    elsif node.attribute?('cloud')
      node.override['ice']['public_hostname'] = node['cloud']['public_hostname']
    else
      node.override['ice']['public_hostname'] = node['fqdn']
    end
  end
  
  # Disable default site first
  nginx_site 'default', :enable => false

  # Generate nginx ice site
  template "#{node['nginx']['dir']}/sites-available/ice" do
    source 'nginx_ice_site.erb'
    mode 0644
    owner node['nginx']['user']
    group node['nginx']['group']
  end

  # Enable ice site
  nginx_site 'ice'
end
