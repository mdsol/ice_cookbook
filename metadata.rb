name             'ice'
maintainer       'Medidata Solutions'
maintainer_email 'cookbooks@mdsol.com'
license          'Apache 2.0'
description      'Installs/Configures ice'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.14'

%w(
  centos
  ubuntu
).each do |os|
  supports os
end

# Cookbook dependencies
%w(
  apt
  chef-sugar
  java
  logrotate
  nginx
  openssl
).each do |cb|
  depends cb
end

depends 'artifact', '>= 1.9.0'
depends 'tomcat', '>= 0.14.0'

source_url 'https://github.com/mdsol/ice_cookbook' if respond_to?(:source_url)
issues_url 'https://github.com/mdsol/ice_cookbook/issues' if respond_to?(:issues_url)
