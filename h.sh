#!/bin/bash
red (){echo -e "\e[31m\e[01m$1\e[0m"};
blue (){echo -e "\e[34m\e[01m$1\e[0m"};
readp (){read -p "$(blue "$1")" $2};
[ -z "$(type -P socat )" ] && apt install socat -y  >/etc/null 2>&1
[ -z "$(type -P curl)" ] && apt install curl -y >/etc/null 2>&1
[ -z "$(type -P netstat)" ] && apt install net-tools -y >/etc/null 2>&1
used=$(netstat -ntpl | grep ":80" |awk -F'[/: ]+' '{print $10}')
# 检查端口是否占用
check_port (){
if [ -z "${used}" ];then
	echo "80端口无占用"
else
	case "${used}" in "nginx")
		echo "释放nginx占用端口"
		sleep 2
		nginx -s stop
		;;
		"trojan")
		echo "trojan"
		sleep 2
		;;
		*)
		echo "${used}"
		;;
		esac
fi
}
email="$(date +%s |md5sum |cut -c 1-6)@gmail.com"
# 安装acme
acme_install (){
curl https://get.acme.sh | sh -s email="${email}"
[[ -z $(/root/.acme.sh/acme.sh -v /etc/null 2>&1) ]] && red "安装失败" || blue "安装成功"
bash /root/.acme.sh/acme.sh --upgrade --use-wget --auto-upgrade

}
# 检查当前ip 
check_ip (){
curl -s
}



# 安装证书
install_ca (){
bash ~/.acme.sh/acme.sh --install-cert -d ${ym} --key-file /root/private.key --fullchain-file /root/cert.crt --ecc
}