#!/bin/bash
curl -s https://raw.githubusercontent.com/lmc999/GamePing/main/GameIP.csv > /tmp/GameIP.csv
ip_file='/tmp/GameIP.csv'

Font_Black="\033[30m";
Font_Red="\033[31m";
Font_Green="\033[32m";
Font_Yellow="\033[33m";
Font_Blue="\033[34m";
Font_Purple="\033[35m";
Font_SkyBlue="\033[36m";
Font_White="\033[37m";
Font_Suffix="\033[0m";

local_isp=$(curl -s -4 --max-time 30 https://api.ip.sb/geoip/ | cut -f1 -d"," | cut -f4 -d '"')

function check_os(){

	os_detail=$(cat /etc/os-release)
	if_debian=$(echo $os_detail | grep 'ebian')
	if_redhat=$(echo $os_detail | grep 'rhel')
	os_version=$(grep 'VERSION_ID' /etc/os-release | cut -d '"' -f 2 | tr -d '.')
	if [ -n "$if_debian" ];then
		InstallMethod="apt install"
	elif [ -n "$if_redhat" ];then
		if [[ "$os_version" -gt 7 ]];then
			InstallMethod="dnf install"
		else
			InstallMethod="yum install"
		fi
	fi
}
check_os

function check_dependencies(){	
	
	bc --help > /dev/null 2>&1
		if [[ "$?" -ne "0" ]];then
			echo -e "${Font_Green}installing bc...${Font_Suffix}" 
			$InstallMethod bc -y > /dev/null 2>&1
		fi
	fping -h > /dev/null 2>&1
		if [[ "$?" -ne "0" ]];then
			echo -e "${Font_Green}installing fping...${Font_Suffix}" 
			$InstallMethod fping -y > /dev/null 2>&1
		fi	
}		
check_dependencies
	

function show_TableHead(){

    echo -n -e "${Font_Yellow}Game\t\tLocation\tLatency\t\tPacket Loss\t\tIDC\t\tServer ID${Font_Suffix}\n"
	echo -e "---------------------------------------------------------------------------------------------------"
}	
show_TableHead

function LOL_Ping(){
	echo -n -e "\t\t\t\t${Font_Red}【League of Legends】${Font_Suffix}\n"
	echo ""
	local Area=$1
	show_TableHead
	if [ -n "$Area" ];then
		cat ${ip_file} | sed "/\<LOL\>/I! d" | sed "/\<$Area\>/I! d" > /tmp/IP_To_Ping.csv
	else
		cat ${ip_file} | sed "/\<LOL\>/I! d" > /tmp/IP_To_Ping.csv
	fi
	local ip_file='/tmp/IP_To_Ping.csv'
	while read -r line || [[ -n $line ]];do
		content=$(echo $line)
		local game=$(echo $content | awk '{print $1}' | cut -f1 -d",")
		local ip=$(echo $content | awk '{print $2}' | cut -f1 -d",")
		local country=$(echo $content | awk '{print $3}' | cut -f1 -d",")
		local idc=$(echo $content | awk '{print $4}' | cut -f1 -d",")
		local area=$(echo $content | awk '{print $5}' | cut -f1 -d",")
		local ServerID=$(echo $content | awk '{print $6}' | cut -f1 -d",")
		#screen -dmS LOL `ping $ip -w 4 -c 4 > /tmp/ping.txt`
		ping $ip -w 4 -c 4 > /tmp/result.txt 2>&1 
		cat /tmp/result.txt | grep '100%' >/dev/null 2>&1
		
		if [[ "$?" -eq "0" ]];then
			ip_prefix=${ip}/24
			newip=$(fping $ip_prefix -ag -r 1 | head -n 1)
			local result=$(ping $newip -w 4 -c 4)
		else
			local result=$(cat /tmp/result.txt)
		fi	
			
		local packetloss=$(echo $result | grep 'packet loss' | sed 's/packet loss.*//' | awk '{print $NF}')	
		local latency=$(echo $result | grep 'avg' | sed 's/.*=//' | cut -f2 -d"/")	
		
		if [ $(echo "$latency < 50" | bc) -eq 1 ];then
			LatencyClor="\033[32m"
		else
			LatencyClor="\033[31m"
		fi	
		
		if [ $(echo "$(echo $packetloss |cut -f1 -d"%") < 5" | bc) -eq 1 ];then
			PacketlossClor="\033[32m"
		else
			PacketlossClor="\033[31m"
		fi
		echo -n -e "${Font_SkyBlue}$game${Font_Suffix}\t\t  ${Font_Purple}$country${Font_Suffix}\t\t${LatencyClor}$latency ms${Font_Suffix}\t    ${PacketlossClor}$packetloss${Font_Suffix}\t\t    ${Font_Blue} $idc${Font_Suffix}\\t\t    ${Font_Red}$ServerID${Font_Suffix}\n"
	done < ${ip_file}	

	echo -e "==================================================================================================="
	echo ""
}

function PUBG_Ping(){
	echo -n -e "\t\t\t\t${Font_Red}【PlayerUnknown's Battlegrounds】${Font_Suffix}\n"
	echo ""
	local Area=$1
	show_TableHead
	if [ -n "$Area" ];then
		cat ${ip_file} | sed "/\<PUBG\>/I! d" | sed "/\<$Area\>/I! d" > /tmp/IP_To_Ping.csv
	else
		cat ${ip_file} | sed "/\<PUBG\>/I! d" > /tmp/IP_To_Ping.csv
	fi
	local ip_file='/tmp/IP_To_Ping.csv'
	while read -r line || [[ -n $line ]];do
		content=$(echo $line)
		local game=$(echo $content | awk '{print $1}' | cut -f1 -d",")
		local ip=$(echo $content | awk '{print $2}' | cut -f1 -d",")
		local country=$(echo $content | awk '{print $3}' | cut -f1 -d",")
		local idc=$(echo $content | awk '{print $4}' | cut -f1 -d",")
		local area=$(echo $content | awk '{print $5}' | cut -f1 -d",")
		local ServerID=$(echo $content | awk '{print $6}' | cut -f1 -d",")
		#screen -dmS LOL `ping $ip -w 4 -c 4 > /tmp/ping.txt`
		ping $ip -w 4 -c 4 > /tmp/result.txt 2>&1 
		cat /tmp/result.txt | grep '100%' >/dev/null 2>&1
		
		if [[ "$?" -eq "0" ]];then
			ip_prefix=${ip}/24
			newip=$(fping $ip_prefix -ag -r 1 | head -n 1)
			local result=$(ping $newip -w 4 -c 4)
		else
			local result=$(cat /tmp/result.txt)
		fi	
			
		local packetloss=$(echo $result | grep 'packet loss' | sed 's/packet loss.*//' | awk '{print $NF}')	
		local latency=$(echo $result | grep 'avg' | sed 's/.*=//' | cut -f2 -d"/")	
		
		if [ $(echo "$latency < 50" | bc) -eq 1 ];then
			LatencyClor="\033[32m"
		else
			LatencyClor="\033[31m"
		fi	
		
		if [ $(echo "$(echo $packetloss |cut -f1 -d"%") < 5" | bc) -eq 1 ];then
			PacketlossClor="\033[32m"
		else
			PacketlossClor="\033[31m"
		fi
		echo -n -e "${Font_SkyBlue}$game${Font_Suffix}\t\t  ${Font_Purple}$country${Font_Suffix}\t\t${LatencyClor}$latency ms${Font_Suffix}\t    ${PacketlossClor}$packetloss${Font_Suffix}\t\t    ${Font_Blue}   $idc${Font_Suffix}\t${Font_Red}     $ServerID${Font_Suffix}\n"
	done < ${ip_file}	

	echo -e "==================================================================================================="
	echo ""
}

function R6S_Ping(){
	echo -n -e "\t\t\t\t${Font_Red}【Tom Clancy's Rainbow Six Siege】${Font_Suffix}\n"
	echo ""
	local Area=$1
	show_TableHead
	if [ -n "$Area" ];then
		cat ${ip_file} | sed "/\<R6S\>/I! d" | sed "/\<$Area\>/I! d" > /tmp/IP_To_Ping.csv
	else
		cat ${ip_file} | sed "/\<R6S\>/I! d" > /tmp/IP_To_Ping.csv
	fi
	
	local ip_file='/tmp/IP_To_Ping.csv'
	while read -r line || [[ -n $line ]];do
		content=$(echo $line)
		local game=$(echo $content | awk '{print $1}' | cut -f1 -d",")
		local ip=$(echo $content | awk '{print $2}' | cut -f1 -d",")
		local country=$(echo $content | awk '{print $3}' | cut -f1 -d",")
		local idc=$(echo $content | awk '{print $4}' | cut -f1 -d",")
		local area=$(echo $content | awk '{print $5}' | cut -f1 -d",")
		local ServerID=$(echo $content | awk '{print $6}' | cut -f1 -d",")
		#screen -dmS LOL `ping $ip -w 4 -c 4 > /tmp/ping.txt`
		ping $ip -w 4 -c 4 > /tmp/result.txt 2>&1 
		cat /tmp/result.txt | grep '100%' >/dev/null 2>&1
		
		if [[ "$?" -eq "0" ]];then
			ip_prefix=${ip}/24
			newip=$(fping $ip_prefix -ag -r 1 | head -n 1)
			local result=$(ping $newip -w 4 -c 4)
		else
			local result=$(cat /tmp/result.txt)
		fi	
			
		local packetloss=$(echo $result | grep 'packet loss' | sed 's/packet loss.*//' | awk '{print $NF}')	
		local latency=$(echo $result | grep 'avg' | sed 's/.*=//' | cut -f2 -d"/")	
		
		if [ $(echo "$latency < 50" | bc) -eq 1 ];then
			LatencyClor="\033[32m"
		else
			LatencyClor="\033[31m"
		fi	
		
		if [ $(echo "$(echo $packetloss |cut -f1 -d"%") < 5" | bc) -eq 1 ];then
			PacketlossClor="\033[32m"
		else
			PacketlossClor="\033[31m"
		fi
		echo -n -e "${Font_SkyBlue}$game${Font_Suffix}\t\t  ${Font_Purple}$country${Font_Suffix}\t\t${LatencyClor}$latency ms${Font_Suffix}\t    ${PacketlossClor}$packetloss${Font_Suffix}\t\t    ${Font_Blue}   $idc${Font_Suffix}\t\t${Font_Red}   $ServerID${Font_Suffix}\n"
	done < ${ip_file}	

	echo -e "==================================================================================================="
	echo ""
}

function ApexLegends_Ping(){
	echo -n -e "\t\t\t\t\t${Font_Red}【Apex Legends】${Font_Suffix}\n"
	echo ""
	local Area=$1
	show_TableHead
	if [ -n "$Area" ];then
		cat ${ip_file} | sed "/\<Apex\>/I! d" | sed "/\<$Area\>/I! d" > /tmp/IP_To_Ping.csv
	else
		cat ${ip_file} | sed "/\<Apex\>/I! d" > /tmp/IP_To_Ping.csv
	fi
	local ip_file='/tmp/IP_To_Ping.csv'
	while read -r line || [[ -n $line ]];do
		content=$(echo $line)
		local game=$(echo $content | awk '{print $1}' | cut -f1 -d",")
		local ip=$(echo $content | awk '{print $2}' | cut -f1 -d",")
		local country=$(echo $content | awk '{print $3}' | cut -f1 -d",")
		local idc=$(echo $content | awk '{print $4}' | cut -f1 -d",")
		local area=$(echo $content | awk '{print $5}' | cut -f1 -d",")
		local ServerID=$(echo $content | awk '{print $6}' | cut -f1 -d",")
		#screen -dmS LOL `ping $ip -w 4 -c 4 > /tmp/ping.txt`
		ping $ip -w 4 -c 4 > /tmp/result.txt 2>&1 
		cat /tmp/result.txt | grep '100%' >/dev/null 2>&1
		
		if [[ "$?" -eq "0" ]];then
			ip_prefix=${ip}/24
			newip=$(fping $ip_prefix -ag -r 1 | head -n 1)
			local result=$(ping $newip -w 4 -c 4)
		else
			local result=$(cat /tmp/result.txt)
		fi	
			
		local packetloss=$(echo $result | grep 'packet loss' | sed 's/packet loss.*//' | awk '{print $NF}')	
		local latency=$(echo $result | grep 'avg' | sed 's/.*=//' | cut -f2 -d"/")	
		
		if [ $(echo "$latency < 50" | bc) -eq 1 ];then
			LatencyClor="\033[32m"
		else
			LatencyClor="\033[31m"
		fi	
		
		if [ $(echo "$(echo $packetloss |cut -f1 -d"%") < 5" | bc) -eq 1 ];then
			PacketlossClor="\033[32m"
		else
			PacketlossClor="\033[31m"
		fi
		echo -n -e "${Font_SkyBlue}$game${Font_Suffix}\t\t  ${Font_Purple}$country${Font_Suffix}\t\t${LatencyClor}$latency ms${Font_Suffix}\t    ${PacketlossClor}$packetloss${Font_Suffix}\t\t    ${Font_Blue}   $idc${Font_Suffix}\\t\t    ${Font_Red} $ServerID${Font_Suffix}\n"
	done < ${ip_file}	

	echo -e "==================================================================================================="
	echo ""
}

function Hypixel_Ping(){
	echo -n -e "\t\t\t\t\t${Font_Red}【Minecraft: Hypixel】${Font_Suffix}\n"
	echo ""
	local Area=$1
	show_TableHead
	if [ -n "$Area" ];then
		cat ${ip_file} | sed "/\<MCH\>/I! d" | sed "/\<$Area\>/I! d" > /tmp/IP_To_Ping.csv
	else
		cat ${ip_file} | sed "/\<MCH\>/I! d" > /tmp/IP_To_Ping.csv
	fi
	
	local ip_file='/tmp/IP_To_Ping.csv'
	while read -r line || [[ -n $line ]];do
		content=$(echo $line)
		local game=$(echo $content | awk '{print $1}' | cut -f1 -d",")
		local ip=$(echo $content | awk '{print $2}' | cut -f1 -d",")
		local country=$(echo $content | awk '{print $3}' | cut -f1 -d",")
		local idc=$(echo $content | awk '{print $4}' | cut -f1 -d",")
		local area=$(echo $content | awk '{print $5}' | cut -f1 -d",")
		local ServerID=$(echo $content | awk '{print $6}' | cut -f1 -d",")
		#screen -dmS LOL `ping $ip -w 4 -c 4 > /tmp/ping.txt`
		ping $ip -w 4 -c 4 > /tmp/result.txt 2>&1 
		cat /tmp/result.txt | grep '100%' >/dev/null 2>&1
		
		if [[ "$?" -eq "0" ]];then
			ip_prefix=${ip}/24
			newip=$(fping $ip_prefix -ag -r 1 | head -n 1)
			local result=$(ping $newip -w 4 -c 4)
		else
			local result=$(cat /tmp/result.txt)
		fi	
			
		local packetloss=$(echo $result | grep 'packet loss' | sed 's/packet loss.*//' | awk '{print $NF}')	
		local latency=$(echo $result | grep 'avg' | sed 's/.*=//' | cut -f2 -d"/")	
		
		if [ $(echo "$latency < 50" | bc) -eq 1 ];then
			LatencyClor="\033[32m"
		else
			LatencyClor="\033[31m"
		fi	
		
		if [ $(echo "$(echo $packetloss |cut -f1 -d"%") < 5" | bc) -eq 1 ];then
			PacketlossClor="\033[32m"
		else
			PacketlossClor="\033[31m"
		fi
		echo -n -e "${Font_SkyBlue}$game${Font_Suffix}\t\t  ${Font_Purple}$country${Font_Suffix}\t\t${LatencyClor}$latency ms${Font_Suffix}\t    ${PacketlossClor}$packetloss${Font_Suffix}\t\t    ${Font_Blue}   $idc${Font_Suffix}${Font_Red}         $ServerID${Font_Suffix}\n"
	done < ${ip_file}	

	echo -e "==================================================================================================="
	echo ""
}

function Call_GameList(){
clear
GameList=$(curl https://raw.githubusercontent.com/d9999pro/GamePing/main/GameList.txt -s)
echo -n -e "${Font_Red}【Suport Game List】${Font_Suffix}\n"
echo ""
echo -n -e "${Font_SkyBlue}$GameList${Font_Suffix}\n"
echo ""
echo ""
echo ""
}

function GamePing(){
LOL_Ping ${1}
PUBG_Ping ${1}
R6S_Ping ${1}
ApexLegends_Ping ${1}
Hypixel_Ping ${1}
}


function Goodbye(){
echo -e "${Font_Green}that is ${Font_Suffix}"
echo -e "${Font_Red}Result in ICMP Ping${Font_Suffix}"
}

clear;

function ScriptTitle(){
echo -e "Online Game Region Latency Test";
echo ""
echo -e "${Font_Green}_${Font_Suffix} ${Font_Yellow}_ ${Font_Suffix}";
echo -e "${Font_Green}_${Font_Suffix} ${Font_Yellow}_${Font_Suffix}";
echo ""
echo -e " ** Time: $(date)";
echo ""
echo ""

}
ScriptTitle

function Start(){
echo -e "${Font_Red}Please select the area to be detected, and press Enter directly to detect the entire area${Font_Suffix}"
echo -e "${Font_SkyBlue}Number【1】：Asia server delay ping test${Font_Suffix}"
echo -e "${Font_SkyBlue}Number【2】：US server delay ping test${Font_Suffix}"
echo -e "${Font_SkyBlue}Number【3】：EU server delay ping test${Font_Suffix}"
echo -e "${Font_SkyBlue}Number【4】：AUS server delay ping test${Font_Suffix}"
echo -e "${Font_SkyBlue}Number【5】：SA server delay ping test${Font_Suffix}"
echo -e "${Font_SkyBlue}Number【0】：View supported game list${Font_Suffix}"
read -p "Number then press Enter" num
}
Start

function RunScript(){
	if [[ -n "${num}" ]]; then
		if [[ "$num" -eq 1 ]]; then
			clear
			ScriptTitle
			GamePing ASIA
			Goodbye
			
		elif [[ "$num" -eq 2 ]]; then
			clear
			ScriptTitle
			GamePing AMERICAS
			Goodbye
			
		elif [[ "$num" -eq 3 ]]; then
			clear
			ScriptTitle
			GamePing EUROPE
			Goodbye
			
		elif [[ "$num" -eq 4 ]]; then
			clear
			ScriptTitle
			GamePing OCEANIA
			Goodbye
			
		elif [[ "$num" -eq 5 ]]; then
			clear
			ScriptTitle
			GamePing LATINAMERICA
			Goodbye
			
		elif [[ "$num" -eq 0 ]]; then
			Call_GameList
			
		else
			echo -e "${Font_Red}Please run again and put the correct number${Font_Suffix}"
			return
		fi	
	else
		clear
		ScriptTitle
		GamePing
		Goodbye
	fi
}	
RunScript
