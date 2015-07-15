require_relative '../../../kitchen/data/spec_helper'

suffix = node['tomcat']['base_version'].to_i < 7 ? node['tomcat']['base_version'] : ''

describe 'should be running tomcat6 on port 8080' do
  describe service("tomcat#{suffix}") do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(8080) do
    it { should be_listening }
  end
end

describe 'should be running nginx on port 80' do
  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(80) do
    it { should be_listening }
  end
end

describe 'should be configured to run a processer' do
  describe file("/var/lib/tomcat#{suffix}/webapps/releases/0.0.4/WEB-INF/classes/ice.properties") do
    its(:content) { should match(/ice\.processor=true/) }
  end
end

describe 'should be configured to run a reader' do
  describe file("/var/lib/tomcat#{suffix}/webapps/releases/0.0.4/WEB-INF/classes/ice.properties") do
    its(:content) { should match(/ice\.reader=true/) }
  end
end

describe 'should be configured to pull billing files from 90 days back' do
  describe file("/var/lib/tomcat#{suffix}/webapps/releases/0.0.4/WEB-INF/classes/ice.properties") do
    processing_start_millis = (Date.today - 90).strftime('%Q')[0..-6] # drop last 6 digits
    its(:content) { should match(/ice\.startmillis=#{processing_start_millis}\d+{5,5}/) }
  end
end
