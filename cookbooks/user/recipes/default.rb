#
# Cookbook Name:: user
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
users = data_bag('users')

users.each do |id|
	user = data_bag_item('users', id)
	home = "/home/#{id}"
	user(id) do
		comment     user['comment']
		password    user['password']
		shell	user['shell']
		supports	:manage_home => true
		action	[	:create,	:manage	]
	end
	directory "/home/#{id}/.ssh" do
		owner "#{id}"
		group "#{id}"
		mode 0755
		action :create
		recursive true
	end
	directory "/home/#{id}" do
		owner "#{id}"
		group "#{id}"
		mode 0755
		action :create	
	end
	key	= user['ssh_keys']
	ssh_dir = home + "/.ssh"
	authorized_keys = ssh_dir + "/authorized_keys"
	file authorized_keys do
		owner	"#{id}"
		group	"#{id}"
		mode	0600
		content	"#{key}"
	end
end