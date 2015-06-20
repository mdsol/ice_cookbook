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
    service node['tomcat']['base_instance'] do
      action :restart
    end
  }
end


# Allow httpd to connect to tomcat for proxy
execute 'selinux httpd_can_network_connect' do
  command '/usr/sbin/setsebool httpd_can_network_connect true'
  only_if { ['rhel', 'fedora'].include?(node['platform_family']) }
end


# Configure logrotate
logrotate_app node['tomcat']['base_instance'] do
  cookbook 'logrotate'
  path "#{node['tomcat']['log_dir']}/catalina.out"
  frequency node['ice']['logrotate_frequency']
  rotate node['ice']['logrotate_rotate']
  create "640 #{node['tomcat']['base_instance']} adm"
  options %w( copytruncate compress missingok )
end

include_recipe 'ice::nginx' if node['ice']['reader']['enabled'] == true and node['ice']['nginx_enabled']
