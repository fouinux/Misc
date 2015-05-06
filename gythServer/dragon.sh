#!/bin/bash

# Hello section
hello="Hello `whoami`, you are on `hostname`"

# Disk section
# See df | tail -$((`df | wc -l` - 1))
disk="Disk usage :\n"
disk="$disk`df -h /dev/sdb1 /dev/sdc1 | awk 'NR == 2, NR == NF {print $6,\" => \                                                                                                                                                             ", $5}'`"

# Uptime
up=$(uptime | awk -F "," '{print "Uptime : ", $1}')

# Users
user=$(w -sh | awk '{print "User : ", $1, "| from : " ,$3}')

# Get the longest line in Users string
length=$(echo -e "$user" | wc -L)

# Create line separator
sep=$(printf "%0.s-" $(seq 1 $length))
sep="\n$sep\n"

# Concat all string
msg=$hello$sep$disk$sep$up$sep$user

echo -e "$msg" | cowsay -n -f dragon
