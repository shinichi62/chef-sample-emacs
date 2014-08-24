#
# Cookbook Name:: emacs
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%w{gcc make ncurses-devel git}.each do |pkg|
  package pkg do
    action :install
  end
end

cookbook_file '/home/vagrant/emacs-24.3.tar.gz' do
  mode 0644
  action :create
end

bash 'install emacs' do
  cwd '/home/vagrant'
  not_if 'ls /usr/local/bin/emacs-24.3'
  code <<-EOH
    tar xzf emacs-24.3.tar.gz
    cd emacs-24.3
    ./configure
    make
    make install
  EOH
end

bash 'install cask' do
  user 'vagrant'
  group 'vagrant'
  cwd '/home/vagrant'
  not_if 'ls /home/vagrant/.cask'
  code <<-EOH
    curl -fsSkL https://raw.github.com/cask/cask/master/go | python
  EOH
end

directory '/home/vagrant/.emacs.d' do
  user 'vagrant'
  group 'vagrant'
  mode    '0775'
  action :create
end

bash 'cask init' do
  user 'vagrant'
  group 'vagrant'
  cwd '/home/vagrant/.emacs.d'
  code <<-EOH
    /home/vagrant/.cask/bin/cask init
    /home/vagrant/.cask/bin/cask
  EOH
end

%w{/home/vagrant/.emacs.d/init.el}.each do |tp|
  template tp do
    mode '0644'
  end
end
