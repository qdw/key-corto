#!/bin/bash

# The install process is idempotent, so this script is safe to run again
# when the user switches to a new version of Key Corto.

MYDIR=$(basename $0)

echo "Install in which directory? [~$USER] " # or login?  or EUID?
read INSTALL_DIR
if [ ! $INSTALL_DIR ]; then
    INSTALL_DIR = ~
fi

echo "Add hook to which file?  Common answers:  /etc/bashrc ~/.bashrc [~/.bashrc]"
read HOOKFILE

source $MYDIR/INSTALL_LIB.sh
generate-keys
create-wallet
install-lib-in $INSTALL_DIR
add-hook-to $HOOKFILE
