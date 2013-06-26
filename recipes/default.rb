#
# Cookbook Name:: ice
# Recipe:: default
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

if node['platform_family'] == 'debian'
  include_recipe 'apt'
end

include_recipe 'java'
include_recipe 'tomcat'

java_options = "#{node['tomcat']['java_options']} -Dice.s3AccessKeyId=#{node['ice']['billing_aws_access_key_id']} -Dice.s3SecretKey=#{node['ice']['billing_aws_secret_access_key']}"

node.override['tomcat']['java_options'] = java_options

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
    directory node['ice']['processor']['localDir'] do
        owner node['tomcat']['user']
        group node['tomcat']['group']
        mode '0755'
      only_if { node['ice']['processor']['enabled'] == true }
    end

    # Create ice local reader work directory
    directory node['ice']['reader']['localDir'] do
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
