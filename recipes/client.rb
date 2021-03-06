#
# Cookbook Name:: munin
# Recipe:: client
#
# Copyright 2010, Opscode, Inc.
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
#

munin_servers = search(:node, "role:#{node['munin']['server_role']} AND chef_environment:#{node.chef_environment}")

package "munin-node"

service "munin-node" do
  supports :restart => true
  action :enable
end

template "#{node['munin']['basedir']}/munin-node.conf" do
  source "munin-node.conf.erb"
  mode 0644
  variables :munin_servers => munin_servers
  notifies :restart, resources(:service => "munin-node")
end

case node[:platform]
when "arch"
  execute "munin-node-configure --shell | sh" do
    not_if { Dir.entries(node['munin']['plugins']).length > 2 }
    notifies :restart, "service[munin-node]"
  end
end

if platform_family?("rhel")
munin_plugin "apache_accesses"
munin_plugin "apache_volume"
munin_plugin "cpu"
munin_plugin "df"
munin_plugin "df_inode"
munin_plugin "diskstats"
munin_plugin "entropy"
munin_plugin "forks"
munin_plugin "fw_packets"
munin_plugin "http_loadtime"
munin_plugin "if_err_" do
  plugin "if_err_eth0"
end
munin_plugin "if_" do
  plugin "if_eth0"
end
munin_plugin "interrupts"
munin_plugin "iostat"
munin_plugin "iostat_ios"
munin_plugin "irqstats"
munin_plugin "load"
munin_plugin "memory"
munin_plugin "open_files"
munin_plugin "open_inodes"
munin_plugin "postfix_mailqueue"
munin_plugin "postfix_mailvolume"
munin_plugin "processes"
munin_plugin "proc_pri"
munin_plugin "swap"
munin_plugin "threads"
munin_plugin "uptime"
munin_plugin "vmstat"
end

