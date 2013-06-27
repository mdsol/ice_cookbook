#require 'minitest-chef-handler'
class RubySpec < MiniTest::Chef::Spec

  it "returns HTTP response OK (200) from http://ice.vagrant/" do
    curl_command = 'curl --silent -H "Host: ice.vagrant" http://localhost/'
    assert `#{curl_command}` == '{"status":200,"data":[]}'
  end

end
