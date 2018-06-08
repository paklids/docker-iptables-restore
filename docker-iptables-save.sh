#!/bin/bash
today=$(date +"%Y%m%d")
iptables-save -t nat > /etc/iptables/nat-${today}
iptables-save -t filter > /etc/iptables/filter-${today}
