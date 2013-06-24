site :opscode

metadata

cookbook 'java'
cookbook 'apt'
cookbook 'openssl'
cookbook 'tomcat'
cookbook 'nginx'
cookbook 'artifact', :git => 'git@github.com:RiotGames/artifact-cookbook.git'

group :integration do
  cookbook "minitest-handler"
  #cookbook "ice_test", :path => "test/cookbooks/ice_test"
end
