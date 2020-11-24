j scripts
Helper scripts, mostly for OpenBSD (and other *nix operating systems)

**unboundblock.sh**: This script uses the ad domain list at https://dbl.oisd.nl, and generates blockhost.conf useful for unbound. Unbound returns NXDOMAIN for these ad domains. Include the generated blockhost.conf file via "include:" directive in the "server:" section of /var/unbound/etc/unbound.conf, something like this: include: /var/unbound/etc/blockhost.conf. Note the blockhost.conf must be placed somewhere under /var/unbound, as unbound runs chroot()ed to this directory.
