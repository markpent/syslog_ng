#
# Cookbook:: test
# Recipe:: rewrite
#
# Copyright:: 2019, Ben Hughes <bmhughes@bmhughes.co.uk>
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

syslog_ng_parser 'p_csv_parser' do
  parser 'csv-parser'
  parser_options 'columns' => '"HOSTNAME.NAME", "HOSTNAME.ID"', 'delimiters' => '"-"', 'flags' => 'escape-none', 'template' => '"${HOST}"'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_parser 'p_kv_parser' do
  parser 'kv-parser'
  parser_options 'prefix' => '".kv."'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_parser 'p_json_parser' do
  parser 'json-parser'
  parser_options 'prefix' => '".json."', 'marker' => '"@json:"'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_parser 'p_iptables_parser' do
  parser 'iptables-parser'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
