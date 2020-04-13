##
# Docker Stealth OpenVPN
#
# @file
# @version 0.1

init:
	bin/init.sh

new_user:
	bin/client.sh

del_user:
	bin/revoke.sh

config_ufw_firewall:
	ufw allow ssh
	ufw allow 993
	ufw enable
	ufw status
# end
