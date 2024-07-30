#!/bin/bash

### Color
Green="\e[92;1m"
RED="\033[31m"
YELLOW="\033[33m"
BLUE="\033[36m"
FONT="\033[0m"
GREENBG="\033[42;37m"
REDBG="\033[41;37m"
OK="${Green}--->${FONT}"
ERROR="${RED}[ERROR]${FONT}"
GRAY="\e[1;30m"
NC='\e[0m'
red='\e[1;31m'
green='\e[0;32m'

### Status
function print_ok() {
    echo -e "${OK} ${BLUE} $1 ${FONT}"
}
function print_install() {
	echo -e "${YELLOW} ============================================ ${FONT}"
    echo -e "${YELLOW} # $1 ${FONT}"
	echo -e "${YELLOW} ============================================ ${FONT}"
    sleep 1
}

function print_error() {
    echo -e "${ERROR} ${REDBG} $1 ${FONT}"
}

function print_success() {
    if [[ 0 -eq $? ]]; then
		echo -e "${Green} ============================================ ${FONT}"
        echo -e "${Green} # $1 Successfully installed"
		echo -e "${Green} ============================================ ${FONT}"
        sleep 2
    fi
}
### Install Xray
function install_xray(){
    print_install "Installing the latest Xray module"
    curl -s ipinfo.io/city >> /etc/xray/city
    curl -s ipinfo.io/org | cut -d " " -f 2-10 >> /etc/xray/isp
    xray_latest="$(curl -s https://api.github.com/repos/dharak36/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
    xraycore_link="https://github.com/NevermoreSSH/Xcore-custompath/releases/download/Xray-linux-64-v1.6.5.1/Xray-linux-64-v1.6.5.1"
    curl -sL "$xraycore_link" -o xray
#    unzip -q xray.zip && rm -rf xray.zip
    mv xray /usr/sbin/xray
    print_success "Xray Core"
    
    cat /etc/xray/xray.crt /etc/xray/xray.key | tee /etc/haproxy/xray.pem
    wget -O /etc/xray/config.json "${REPO}xray/config.json" >/dev/null 2>&1 
    #wget -O /usr/sbin/xray/ "${REPO}bin/xray" >/dev/null 2>&1
    wget -O /usr/sbin/websocket "${REPO}bin/ws" >/dev/null 2>&1
    wget -O /etc/websocket/tun.conf "${REPO}xray/tun.conf" >/dev/null 2>&1 
    wget -O /etc/systemd/system/ws.service "${REPO}xray/ws.service" >/dev/null 2>&1 
    wget -q -O /etc/ipserver "${REPO}server/ipserver" && bash /etc/ipserver >/dev/null 2>&1

    # > Set Permission
    chmod +x /usr/sbin/xray
    chmod +x /usr/sbin/websocket
    chmod 644 /etc/websocket/tun.conf
    chmod 644 /etc/systemd/system/ws.service

    # > Create Service
    rm -rf /etc/systemd/system/xray.service.d
    cat >/etc/systemd/system/xray.service <<EOF
[Unit]
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/sbin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target

EOF
print_success "Xray C0re"
}

    # > Bersihkan History
    alias bash2="bash --init-file <(echo '. ~/.bashrc; unset HISTFILE')"
    clear
