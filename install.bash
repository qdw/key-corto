#!/usr/bin/env bash

mkdir ~/.key-corto \ &&

cat <<EOF >> ~/.bashrc
source ~/.key-corto/key-corto.bash
EOF
