#
# Cookbook Name:: ice
# Recipe:: default
#
# Copyright 2015 Medidata Solutions Worldwide
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

include_recipe 'chef-sugar'

include_recipe 'apt' if debian?

include_recipe 'java'
include_recipe 'tomcat'
include_recipe 'logrotate'

java_options = "#{node['tomcat']['java_options']} -Dice.s3AccessKeyId=#{node['ice']['billing_aws_access_key_id']} -Dice.s3SecretKey=#{node['ice']['billing_aws_secret_key']}"

node.override['tomcat']['java_options'] = java_options
node.override['nginx']['default_site_enabled'] = false

artifact_deploy 'ice' do
  version node['ice']['version']
  if node['ice']['version'] == 'stable'
    artifact_location 'https://netflixoss.ci.cloudbees.com/job/ice-master/lastStableBuild/artifact/target/ice.war'
  else
    artifact_location "#{node['ice']['war_url']}/ice-#{node['ice']['version']}.war"
    artifact_checksum node['ice']['checksum']
  end
  deploy_to node['tomcat']['webapp_dir']
  owner node['tomcat']['user']
  group node['tomcat']['group']
  skip_manifest_check true
  keep 2
  should_migrate false
  force node['ice']['force_deploy'] ? true : false
  action :deploy

  before_deploy proc {
    # Create ice local procesor work directory
    directory node['ice']['processor']['local_dir'] do
      owner node['tomcat']['user']
      group node['tomcat']['group']
      mode '0755'
      only_if { node['ice']['processor']['enabled'] == true }
    end

    # Workaround for https://github.com/Netflix/ice/issues/100
    %w( tagdb usage_daily usage_monthly usage_weekly cost_daily cost_monthly cost_weekly usage_hourly cost_hourly ).each do |dir|
      directory "#{node['ice']['processor']['local_dir']}/#{dir}_AWS Import" do
        owner node['tomcat']['user']
        group node['tomcat']['group']
        mode '0755'
        only_if { node['ice']['processor']['enabled'] == true && node['ice']['processor']['issue_100_workaround'] == true }
      end
    end

    # Create ice local reader work directory
    directory node['ice']['reader']['local_dir'] do
      owner node['tomcat']['user']
      group node['tomcat']['group']
      mode '0755'
      only_if { node['ice']['reader']['enabled'] == true }
    end
  }

  configure proc {
    # Create ice.properties file
    template "#{release_path}/WEB-INF/classes/ice.properties" do
      source 'ice.properties.erb'
      owner node['tomcat']['user']
      group node['tomcat']['group']
      mode '0644'
    end
  }

  restart proc {
    service "tomcat#{node['tomcat']['base_version']}" do
      action :restart
    end
  }
end

# Configure logrotate
logrotate_app "tomcat#{node['tomcat']['base_version']}" do
  cookbook 'logrotate'
  path "/var/log/tomcat#{node['tomcat']['base_version']}/catalina.out"
  frequency node['ice']['logrotate_frequency']
  rotate node['ice']['logrotate_rotate']
  create "640 tomcat#{node['tomcat']['base_version']} adm"
  options %w( copytruncate compress missingok )
end

if node['ice']['reader']['enabled'] == true
  # Ugly hack to fix this issue: https://github.com/miketheman/nginx/issues/248
  node.default['nginx']['pid'] = '/run/nginx.pid' if ubuntu_trusty?

  include_recipe 'nginx::default'

  # Configure nginx site reverse proxy
  if node['ice']['public_hostname'].nil?
    if node.attribute?('ec2')
      node.override['ice']['public_hostname'] = node['ec2']['public_hostname']
    elsif node.attribute?('cloud')
      node.override['ice']['public_hostname'] = node['cloud']['public_hostname']
    else
      node.override['ice']['public_hostname'] = node['fqdn']
    end

    if node['ice']['nginx_port'] != 80
      node.override['ice']['public_hostname'] += ":#{node['ice']['nginx_port']}"
    end
  end

  # Disable default site first
  nginx_site 'default', enable: false

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
end
