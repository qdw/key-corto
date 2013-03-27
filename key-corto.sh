################################################################################
# Key Corto:  a tiny utility for storing and retrieving passwords in an
# encrypted file
#   by Quinn Weaver
################################################################################

kc-decrypt() { # Helper function:  decrypt the encrypted passwords file.
    gpg $KC_GPGOPTS --decrypt $KC_WALLET
}

pass() { # Grep lines from my encrypted passwords file.
    if [[ $! != 0 ]]; then
        echo 'Usage:  pass # It will prompt you for the search string...'
    else
        echo "Please enter the string or regular expression to search for."
        read REGEX
        kc-decrypt | grep "$REGEX"
    fi
}

padd() { # Add a line to my encrypted passwords file.
    if [[ $# != 0 ]]; then
        echo 'Usage:  padd # It will prompt you for the line to add...'
    else        
        cp $KC_WALLET $KC_WALLET.bak

        echo "Please enter the line to add."
        read NEW_LINE
        TFILE=$KC_WALLET.tmp
        (kc-decrypt && echo $NEW_LINE) | gpg $KC_GPGOPTS --encrypt > $TFILE \
            && mv $TFILE $KC_WALLET
    fi
}
