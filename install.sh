#!/bin/bash

GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
CYAN=$(tput setaf 6)
RED=$(tput setaf 1)
RESET=$(tput sgr0)
if [ -f python_key.py ]; then
    first_line=$(head -n 1 python_key.py)
    if [ "$first_line" != "V=1" ]; then
        rm python_key.py
        echo "Updating python_key.py..."
        curl -fsSL -o python_key.py https://raw.githubusercontent.com/arshiacomplus/Quick_Warp_on_Warp/main/python_key.py || { echo \"Failed to download python_key.py. Exiting.\"; exit 1; }
        
    fi
else
    echo "install python_key.py"
    curl -fsSL -o python_key.py https://raw.githubusercontent.com/arshiacomplus/Quick_Warp_on_Warp/main/python_key.py || { echo \"Failed to download python_key.py. Exiting.\"; exit 1; }

fi
get_values() {
python python_key.py
readarray -t lines < keys.txt

# اختصاص دادن داده‌ها به متغیرها
ipv6="${lines[0]}"
private_key="${lines[1]}"
public_key="${lines[2]}"
reserved="${lines[3]}"
    

echo "$ipv6@$private_key@$public_key@$reserved"
}

case "$(uname -m)" in
	x86_64 | x64 | amd64 )
	    cpu=amd64
	;;
	i386 | i686 )
        cpu=386
	;;
	armv8 | armv8l | arm64 | aarch64 )
        cpu=arm64
	;;
	armv7l )
        cpu=arm
	;;
	* )
	echo "The current architecture is $(uname -m), temporarily not supported"
	exit
	;;
esac

cfwarpIP(){
echo "download warp endpoint file base on your CPU architecture"
if [[ -n $cpu ]]; then
curl -L -o warpendpoint -# --retry 2 https://raw.githubusercontent.com/arshiacomplus/Quick_Warp_on_Warp/main/cpu/$cpu
fi
}

endipv4(){
	n=0
	iplist=100
	while true
	do
		temp[$n]=$(echo 162.159.192.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 162.159.193.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 162.159.195.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 188.114.96.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 188.114.97.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 188.114.98.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 188.114.99.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
	done
	while true
	do
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 162.159.192.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 162.159.193.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 162.159.195.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 188.114.96.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 188.114.97.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 188.114.98.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 188.114.99.$(($RANDOM%256)))
			n=$[$n+1]
		fi
	done
}


endipresult(){
temp_var=$1
echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u > ip.txt
ulimit -n 102400
chmod +x warpendpoint
./warpendpoint
clear
echo "${GREEN}successfully generated ipv4 endip list${RESET}"
echo "${GREEN}successfully create result.csv file${RESET}"
echo "${CYAN}Now we're going to process result.csv${RESET}"
process_result_csv $temp_var
rm -rf ip.txt warpendpoint result.csv
exit
}



process_result_csv() {
count_conf=$1

values=$(get_values)
w_ip=$(echo "$values" | cut -d'@' -f1)
w_pv=$(echo "$values" | cut -d'@' -f2)
w_pb=$(echo "$values" | cut -d'@' -f3)
w_res=$(echo "$values" | cut -d'@' -f4)
sed -i '1,4d' keys.txt
i_values=$(get_values)
i_w_ip=$(echo "$i_values" | cut -d'@' -f1)
i_w_pv=$(echo "$i_values" | cut -d'@' -f2)
i_w_pb=$(echo "$i_values" | cut -d'@' -f3)
i_w_res=$(echo "$i_values" | cut -d'@' -f4)
sed -i '1,4d' keys.txt

    # تعداد سطرهای فایل result.csv را بدست آورید
    num_lines=$(wc -l < ./result.csv)
    echo ""
    echo "We have considered the number of ${num_lines} IPs."
    echo ""

if [ "$count_conf" -lt "$num_lines" ]; then
    num_lines=$count_conf
elif [ "$count_conf" -gt "$num_lines" ]; then
    echo "Warning: The number of IPs found is less than the number you want!"
    num_lines=$count_conf
fi




    # برای هر سطر در result.csv دستورات را اجرا کنید
    for ((i=2; i<=$num_lines; i++)); do
        # اطلاعات مورد نیاز از هر سطر را دریافت کنید
        local line=$(sed -n "${i}p" ./result.csv)
        local endpoint=$(echo "$line" | awk -F',' '{print $1}')
        local ip=$(echo "$endpoint" | awk -F':' '{print $1}')
        local port=$(echo "$endpoint" | awk -F':' '{print $2}')

# ترکیب رشته و متغیرها در یک متغیر دیگر
new_json='{
      "type": "wireguard",
      "tag": "Warp-IR'"$i"'",
      "local_address": [
        "172.16.0.2/32",
        "'"$w_ip"'"
      ],

      "private_key": "'"$w_pv"'",
      "peer_public_key": "'"$w_pb"'",
      "server": "'"$ip"'",
      "server_port": '"$port"',
      "reserved": '$w_res',

      "mtu": 1280,
      "fake_packets": "5-10",
      "fake_packets":"1-3",
      "fake_packets_size":"10-30",
      "fake_packets_delay":"10-30",
      "fake_packets_mode":"m4"
    },
    {
      "type": "wireguard",
      "tag": "Warp-Main'"$i"'",
      "detour": "Warp-IR'"$i"'",
      "local_address": [
          "172.16.0.2/32",
          "'"$i_w_ip"'"
      ],
      
      "private_key": "'"$i_w_pv"'",
      "server": "'"$ip"'",
      "server_port": '"$port"',
      "peer_public_key": "'"$i_w_pb"'",
      "reserved": '$i_w_res',  

      "mtu": 1330,
      "fake_packets_mode":"m4"
    }'


    temp_json+="$new_json"
    # اضافه کردن خط خالی به محتوای متغیر موقت
if [ $i -lt $num_lines ]; then
    temp_json+=","
fi

    done
full_json='
{
  "outbounds": 
  [
    '"$temp_json"'
  ]
}
'
echo "$full_json" > output.json
echo ""
echo "${GREEN}Upload Files to Get Link${RESET}"
echo "------------------------------------------------------------"
echo ""
echo "Your link:"
curl https://bashupload.com/ -T output.json | sed -e 's#wget#Your Link#' -e 's#https://bashupload.com/\(.*\)#https://bashupload.com/\1?download=1#'
echo "------------------------------------------------------------"
echo ""
mv output.json output_$(date +"%Y%m%d_%H%M%S").json

}
menu() {
    clear
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo "--------------- DDS-WOW -----------------------------"
    echo ""
    echo -e "\e[1;34mDailyDigitalSkills\e[0m  ：github.com/azavaxhuman"
    echo -e "\e[1;34mYoutube\e[0m  ：youtube.com/DailyDigitalSkills"
    echo ""
    echo ""
    echo ""
    echo "---------------Credits-----------------------------"
    echo ""
    echo -e "\e[1;31mForked by Arshiacomplus\e[0m"
    echo -e "\e[1;32mYonggekkk\e[0m  ：github.com/yonggekkk"
    echo -e "\e[1;32mElfina Tech\e[0m  : github.com/Elfiinaa"
    echo -e "\e[1;32mElfina Tech(YT)\e[0m  : youtube.com/@ElfinaTech"
    echo -e "\e[1;32mArshiacomplus\e[0m  : github.com/arshiacomplus/"
    echo -e "\e[1;32mArshiacomplus Tel\e[0m  : t.me/arshia_mod_fun"
    
    echo ""
    echo ""
    echo "Welcome to DDS-WOW(WARP on Warp)"
    echo "1. Automatic scanning and execution (Android / Linux)"
    echo "2. Import custom IPs with result.csv file (windows)"
    read -r -p "Please choose an option: " option

    if [ "$option" = "1" ]; then
        echo "How many configurations do you need?"
        read -r -p "Number of required configurations (suggested 1 or 5): " number_of_configs
        cfwarpIP
        endipv4
        endipresult "$number_of_configs"
    elif [ "$option" = "2" ]; then
        read -r -p "Number of required configurations (suggested 1 or 5): " number_of_configs
        process_result_csv "$number_of_configs"
    else
        echo "Invalid option"
    fi
}

menu
