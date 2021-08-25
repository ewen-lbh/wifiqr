function wifiqr --description "Create a QR code of a WiFi network for easy access. Type wifiqr for help."
	set --local name ""
	set --local password ""
	set --local security_type "WPA"
	if test (count $argv) = 1 && test "$argv[1]" = "help"
		echo "wifiqr [<name> [<password> [WPA|WEP]]]"
		echo "if no arguments are provided, the currently-connected network is used."
		return
	end
	if test (count $argv) -eq 0
		# get current wifi SSID
		echo "- Getting current Wi-Fi connection name" >&2
		set name (nmcli -f IN-USE,SSID dev wifi | grep -E '^\*' | sed -E 's/^\*\s*//' | sed -E 's/\s*$//')
	else
		set name $argv[1]
	end
	if test (count $argv) -ge 2
		set password $argv[2]
		if test (count $argv) -ge 3
			set security_type $argv[3]
		end
	else
		# get security type
		set -l keyfile "/etc/NetworkManager/system-connections/$name.nmconnection"
		echo "- Getting password & security type" >&2
		switch (sudo cat $keyfile | grep -E 'key-mgmt=' | cut -d= -f2)
			case wpa-psk
				set security_type WPA
				set password ""(sudo cat $keyfile | grep -E 'psk=' | sed 's/^psk=//')""
			case '*'
				echo "unsupported key management type. Expected key-mgmt=psk" 
				return 1
		end
	end

	if not echo $security_type | grep -E 'WPA|WEP' >/dev/null
		echo "Invalid security type $security_type. Valid types are WPA or WEP."
		return 1
	end

	set data "WIFI:S:$name;T:$security_type;P:$password" 
	echo "- Generating QR code for data:" >&2
	echo $data

	qrcode "$data" | display
end
	
