# MikroTik-IPsecBan
This script parses log and add to blacklist IP which caused IPsec errors

How to use

Create logging action or use memory

	/system logging action
	add memory-lines=50 name=YourAction target=memory
	/system logging
	add action=YourAction topics=ipsec

Create script

	/system script
	add dont-require-permissions=no name=IPsecBan owner=admin policy=\
		ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
		source=" Put Here Script "

Create firewall rule and Blacklist

	/ip firewall raw
	add action=drop chain=prerouting comment="Drop from blacklist" in-interface=ether-YourWANinterface \
		src-address-list=YourBlacklist
	/ip firewall address-list add list=YourBlacklist

Setup script

	bufferName is YourAction or memory
	listName is YourBlacklist
	timeout is YourTimeout

Create scheduler witch your own interval, start-date and start-time

	/system scheduler
	add interval=1d name=pptpBan on-event="/system script run IPsecBan" policy=\
		ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=oct/01/2018 start-time=00:00:10


This script adds to the blacklist IPv4 addresses which:

- caused IPsec errors like these:
		
		192.0.2.0 failed to get valid proposal.
		192.0.2.0 failed to pre-process ph1 packet (side: 1, status 1).
		192.0.2.0 phase1 negotiation failed.
