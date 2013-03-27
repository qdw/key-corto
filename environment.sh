set -a

# Variables used by INSTALL.sh
KC_NAME             =  key-corto
KC_GPGUSER          =  $KC_NAME--$USER # or $LOGIN?
KC_LIBNAME          =  $KC_NAME.sh
KC_WALLET_BASENAME  =  $KC_NAME-wallet
KC_WALLET_FILENAME  =  $KC_WALLET_BASENAME.asc
KC_GPGOPTS          =  "--batch --quiet --no-tty --armor --user $KC_GPGUSER"

set +a
