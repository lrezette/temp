#!/bin/sh

arch=$(uname -a)

cpu=$(grep "physical id" /proc/cpuinfo | sort -u | wc -l)
vcpu=$(grep -c ^processor /proc/cpuinfo)

ram_total=$(free --mega | awk '$1 == "Mem:" {print $2}')
ram_used=$(free --mega | awk '$1 == "Mem:" {print $3}')
ram_percent=$(free --mega | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

disk_total=$(df -BG / | awk 'NR==2 {gsub("G", "", $2); print $2}')
disk_used=$(df -m / | awk 'NR==2 {print $3}')
disk_percent=$(df / | awk 'NR==2 {print $5}')

cpu_percent=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | awk '{printf("%.1f", $1)}')

last_reboot=$(who -b | awk '{print $3, $4}')

lvm_check=$(lsblk | grep -q "lvm" && echo "yes" || echo "no")

tcp=$(ss -ta | grep ESTAB | wc -l)

user_log=$(users | wc -w)

ip=$(hostname -I | awk '{print $1}')
mac=$(ip link show | awk '/ether/ {print $2}' | head -n 1)

sudo=$(journalctl _COMM=sudo 2>/dev/null | grep -c COMMAND)

wall "#Architecture: $arch
#CPU physical : $cpu
#vCPU : $vcpu
#Memory Usage: ${ram_used}/${ram_total}MB (${ram_percent}%)
#Disk Usage: ${disk_used}/${disk_total}Gb (${disk_percent})
#CPU load: ${cpu_percent}%
#Last boot: $last_reboot
#LVM use: $lvm_check
#Connexions TCP : $tcp ESTABLISHED
#User log: $user_log
#Network: IP $ip ($mac)
#Sudo : $sudo cmd"
