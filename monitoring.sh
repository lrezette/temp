#! /bin/bash

arch=$(uname -a)

cpu=$(grep "physical id" /proc/cpuinfo | wc -l)

vcpu=$(grep -c processor /proc/cpuinfo)

ram_total=$(free --mega | awk '$1 == "Mem:" {print $2}')
ram_free=$(free --mega | awk '$1 == "Mem:" {print $3}')
ram_percent=$(free --mega | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

disk_total=$(df -BG / | awk 'NR==2 {print substr($2, 1, length($2)-1) "Go"}')
disk_used=$(df -m / | awk 'NR==2 {print $3}')
disk_percent=$(df / | awk 'NR==2 {print $5}')

cpu_percent=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')

last_reboot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

lvm_check=$(if sudo lvdisplay &> /dev/null; then echo "yes"; else echo "no"; fi)

tcp=$(ss -ta | grep ESTAB | wc -l)

user_log=$(users | wc -w)

ip=$(hostname -I)
mac=$(ip link show | awk '/ether/ {print $2}')

sudo=$(history | grep -c 'sudo')

wall "	Architecture: $arch
	CPU physical: $cpuf
	vCPU: $cpuv
	Memory Usage: $ram_use/${ram_total}MB ($ram_percent%)
	Disk Usage: $disk_use/${disk_total} ($disk_percent%)
	CPU load: $cpu_fin%
	Last boot: $lb
	LVM use: $lvmu
	Connections TCP: $tcpc ESTABLISHED
	User log: $ulog
	Network: IP $ip ($mac)
	Sudo: $cmnd cmd"
