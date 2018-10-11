:local bufferName "ipsecBuffer";
:local listName "Blacklist";
:local timeout 180d;

:foreach line in=[/log find buffer=$bufferName] do={
	:do {
		:local content [/log get $line message];

		#Bruteforce IPsec
		:if ([:find $content "failed to get valid proposal"] >= 0)\
		do={
			:local position "";
			:local badIP "";
			:set position [:find $content " failed to get valid proposal"];
			:set badIP [:pick $content 0 $position];

			:if ([:len [/ip firewall address-list find address=$badIP and list=$listName]] <= 0)\
			do={
				/ip firewall address-list add list=$listName address=$badIP timeout=$timeout comment="by IPsecBan";
				:log warning "ip $badIP has been banned (IPsec error)";
			}
		}
	} on-error={ :log error "IPsecBan script has crashed"; }
}
:log info "IPsecBan script was executed properly";