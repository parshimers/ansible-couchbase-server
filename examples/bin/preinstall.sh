#!/bin/bash

# File: examples/bin/preinstall.sh - convenience script to add 
# Couchbase Server VM node host information to /etc/hosts for Vagrant

cb1="10\.1\.42\.10"
txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
bakgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset

# Log stuff
function logmsg {
    msgtype="$1"
    msgtxt="$2"
    case "${msgtype}" in
        greeting)
            printf "🌞  ${txtylw}${msgtxt}\n"
            ;;
        info)
            printf "💬  ${txtwht}${msgtxt}\n"
            ;;
        success)
            printf "✅  ${txtgrn}${msgtxt}\n"
            ;;
        notice)
            printf "🚩  ${txtylw}${msgtxt}\n"
            ;;
        alert)
            printf "⛔️  ${txtred}${msgtxt}\n" >&2
            ;;
        *)
            printf "⁉️  ${txtwht}${msgtxt}\n" >&2
            ;;
    esac 
}

# Check if sudo will need password
function sudocheck {
  logmsg info "Enter your user account password for sudo if prompted."
  sudo true
}

# Add hosts entries if necessary
function add_hosts {
  if grep $cb1 /etc/hosts > /dev/null 2>&1; then
    logmsg success "Couchbase Server VM node information present in /etc/hosts"
  else
    sudocheck
    sudo sh -c "echo '# Couchbase Server Vagrant virtual machine hosts
10.1.42.10 cb1.local cb1
10.1.42.20 cb2.local cb2
10.1.42.30 cb3.local cb3
' >> /etc/hosts"
    logmsg success "Couchbase Server node host information added to /etc/hosts"
  fi
}

# Install Vagrant Hosts plugin if necessary
function vagrant_hosts_plugin {
  if vagrant plugin list | grep vagrant-hosts > /dev/null 2>&1; then
    logmsg success "Vagrant Hosts plugin is installed"
  else
    vagrant plugin install vagrant-hosts > /dev/null 2>&1
    logmsg success "Installed Vagrant Hosts plugin"
  fi
}

add_hosts
vagrant_hosts_plugin
