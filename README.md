# scripts
Helper scripts, mostly for OpenBSD (and other *nix operating systems)

**unboundblock.sh**: Generate blockhost.conf for unbound using the ad domain list at https://dbl.oisd.nl. Unbound returns NXDOMAIN for these ad domains. Include the generated blockhost.conf file via "include:" directive in the "server:" section of /var/unbound/etc/unbound.conf, something like this: include: /var/unbound/etc/blockhost.conf. Note the blockhost.conf must be placed somewhere under /var/unbound, as unbound runs chroot()ed to this directory.

**getkishore.sh**: Retrieve the pdf versions of the Kishore magazine, published since 1973. Note the origin server can be slow, and the script may need to run for several hours to download the entire archive. Archive: http://kishor.ebalbharati.in/Archive/

**certexp.sh**: Generate csv file listing certificate expiry and number of days remaining until expiration for domain(s). FQDN or IP address specified in a file, one per line.

**log.sh**: LOG() function. Can be imported into another script.
