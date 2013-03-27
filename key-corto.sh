export GPGUSER=Nobody
export GPGOPTS="--batch --quiet --no-tty --armor --user $GPGUSER"
export WALLET=~/wallet.asc

# _dginit() { # Helper function:  create the key and file, iff they don't exist.
#     if [ ! -e $WALLET ]; then
#         touch $WALLET
#     fi
# 
#     gpg2 --list-keys Nobody
#     if [ $? != 0 ]; then
#         gpg2 --gen-key
# }

_decryp() { # Helper function:  decrypt the encrypted passwords file.
    gpg2 $GPGOPTS --decrypt $WALLET
}

pass() { # Grep lines from my encrypted passwords file.
    read -e -p 'Enter a regex to grep for (case-insensitive): ' REGEX
       # -p 'Text of the prompt> '
       # -e means use the readline library.
       # (-s means don't echo what the user types, but that hurts usability).
       
    _decryp | grep -i "$REGEX"
}

padd() { # Add a line to my encrypted passwords file.
    read -e -p 'Enter a password line to add (freeform, all one line): ' NEW_ENTRY
       # -p 'Text of the prompt> '
       # -e means use the readline library.
       # (-s means don't echo what the user types, but that hurts usability).

    cp $WALLET $WALLET.bak
    SWAP_FILE=$WALLET.tmp
    (_decryp $WALLET && echo $NEW_ENTRY) | gpg2 $GPGOPTS --encrypt > $SWAP_FILE \
        && mv $SWAP_FILE $WALLET
}

run_gpg_agent_idempotently() {
    # This code is from gpg-agent(1) man page:
    if test -f $HOME/.gpg-agent-info && \
        kill -0 $(cut -d: -f 2 $HOME/.gpg-agent-info) 2>/dev/null; then
        GPG_AGENT_INFO=$(cat $HOME/.gpg-agent-info)
        export GPG_AGENT_INFO
    else
        eval $(gpg-agent --daemon)
        echo $GPG_AGENT_INFO >$HOME/.gpg-agent-info
    fi
}

# Run gpg_agent in the background, so that the user has to supply credentials
# only once in a while, not each time she runs pass or padd. If you dislike
# this feature for security reasons, comment out the following line:
run_gpg_agent_idempotently
