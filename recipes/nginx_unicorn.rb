# encoding: utf-8

include_recipe 'gitlab::default'

# Render unicorn template
template "#{node['gitlab']['app_home']}/config/unicorn.rb" do
  owner node['gitlab']['user']
  group node['gitlab']['group']
  mode 0644
end

package 'daemon'

# Render unicorn_rails init script
template "/etc/init.d/unicorn_rails" do
  owner "root"
  group "root"
  mode 0755
  source "unicorn_rails.init.erb"
end

# Start unicorn_rails and nginx service
%w{ unicorn_rails nginx }.each do |svc|
  service svc do
    action [ :start, :enable ]
  end
end

# Render nginx default vhost config
template "/etc/nginx/conf.d/default.conf" do
  owner "root"
  group "root"
  mode 0644
  source "nginx.default.conf.erb"
  notifies :restart, "service[nginx]"
end
