name             'ice'
maintainer       'Ray Rodriguez'
maintainer_email 'rayrod2030@gmail.com'
description      'Installs/Configures ice'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.8'

%w{ ubuntu centos }.each do |os|
    supports os
end

# Cookbook dependencies
%w{ java apt tomcat nginx openssl artifact }.each do |cb|
  depends cb
end
