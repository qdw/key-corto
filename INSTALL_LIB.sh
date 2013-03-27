#!/bin/bash

MY_DIR=$(basename $0)

export ENVFILE=$MY_DIR/environment.sh
source $ENVFILE

# All these functions are idempotent, so it's safe to run them again
# when the user switches to a new version of Key Corto.

generate-keys() {
    cd
    gpg --no-tty --list-keys $GPGUSER
    if [ $? != 0 ]; then
        gpg --batch --gen-key $MY_DIR/gpg-user-spec
    fi
}

create-wallet() {
    # Idempotent:  creates the wallet only if it is not present.
    # That way, this script is safe if the user is up/downgrading
    # from another version of Key Corto.
    file (idempotent; OK for upgrades).
    if [ ! -e $WALLET ]; then
        touch $WALLET_SANS_EXTENSION
        gpg $GPGOPTS --encrypt $WALLET_SANS_EXTENSION
    fi
}

install-lib-in() {
    TARGET_DIR=$1
    cat $ENVFILE $MY_DIR/$LIBNAME > $TARGET_DIR/$LIBNAME
}

add-hook-to() {
    INSTALL_DIR=$1
    HOOK_FILE=$2

    HOOK="source $TARGET_DIR/$LIBNAME"

    if [ ! -e ~/$HOOK_FILE ]; then
        # There's no ~/.bashrc.  Create one.
        echo $HOOK > ~/$HOOK_FILE
    else
        grep "^$HOOK$" ~/$HOOK_FILE >/dev/null 2>&1
        if [ $? != 0 ]; then
            # Hook is missing.  Insert it.
            echo $HOOK >> ~/$HOOK_FILE
        fi
    fi
}
