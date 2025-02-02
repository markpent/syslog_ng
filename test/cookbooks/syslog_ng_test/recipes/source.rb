#
# Cookbook:: test
# Recipe:: source
#
# Copyright:: 2018, Ben Hughes <bmhughes@bmhughes.co.uk>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

with_run_context :root do
  find_resource(:execute, 'syslog-ng-config-test') do
    command '/sbin/syslog-ng -s'
    action :nothing
  end
  find_resource(:service, 'syslog-ng') do
    action :nothing
  end
end

syslog_ng_source 's_test_tcp' do
  driver 'tcp'
  parameters(
    'ip' => '127.0.0.1',
    'port' => '5514'
  )
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_source 's_test_pipe' do
  driver 'pipe'
  path '/dev/pipe'
  parameters(
    'pad-size' => 2048
  )
  description 'pipe source testing'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_source 's_test_tcpudp' do
  configuration(
    [
      'tcp' => {
        'parameters' => {
          'ip' => '127.0.0.1',
          'port' => '5514',
        },
      },
      'udp' => {
        'parameters' => {
          'ip' => '127.0.0.1',
          'port' => '5514',
        },
      },
    ]
  )
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_source 's_test_network_multiline' do
  configuration(
    [
      {
        'network' => {
          'parameters' => {
            'transport' => 'tcp',
            'ip' => '127.0.0.1',
            'port' => '5518',
          },
        },
      },
      {
        'network' => {
          'parameters' => {
            'transport' => 'udp',
            'ip' => '127.0.0.1',
            'port' => '5518',
          },
        },
      },
    ]
  )
  multiline true
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_source 's_test_network_multiple' do
  driver %w(network network)
  parameters(
    [
      {
        'transport' => 'tcp',
        'ip' => '127.0.0.1',
        'port' => '5518',
      },
      {
        'transport' => 'udp',
        'ip' => '127.0.0.1',
        'port' => '5518',
      },
    ]
  )
  multiline true
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
