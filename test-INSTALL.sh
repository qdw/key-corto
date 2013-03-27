#!/bin/bash
# Unit tests for the Key Corto installation process

export MY_DIR=$(basename $0)
source MY_DIR/INSTALL_LIB.sh

Somehow change the directory where things are happening from ~ to a test-only
dir.  Requires variable-fu...

test-generate-keys() {
    