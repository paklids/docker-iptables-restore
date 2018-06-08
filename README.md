# docker-iptables-restore !!!Experimental!!!
When pushing iptables to a docker host it is possible to clobber the existing rules created by docker. 
Backup and later restore these rules.

## How it works:
docker-iptables-save.sh
Bash script that leverages iptables-persistent (iptables-save and iptables-restore) to make a backup 
of the NAT table and the FILTER table and places those in /etc/iptables with a rudimentary timestamp

docker-iptables-restore.sh
Bash script that restores only the relevant rules from the FORWARD, DOCKER & DOCKER-ISOLATION chains
to the FILTER table (mixed in with the rules that you've just pushed to the system)
If a NAT table already exists, it skips that and uses the ones you've pushed, otherwise restores the NAT 
table that existed on that host from before.

## Where are the dragons?
Don't run this close to the end of the day (see your system clock) because it uses the day to identify the 
files to restore.

## What has this been run on?
Ubuntu 16.04 running Docker 17.04.0, but should work on other Debian based systems. I have not tested
any of the DOCKER-USER chains, but that should not be hard to add.
