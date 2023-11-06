#!/bin/bash

function error() {
    echo -e "\033[0;31m[X] Error: $1\033[0m"
}

function create() {
    if [ $1 == "" ]; then
      error "Please specify the name of the root to create"
      return
    fi
    mkdir -p ~/.babies/roots/"$1"
    mkdir -p ~/.babies/roots/"$1"/usr/bin
    cp /usr/bin/busybox "$1"/usr/bin/busybox
    for cmd in $(busybox --list); do
        echo '#!/usr/bin/env busybox ash' > "$1"/usr/bin/$cmd
        echo "# Babies Root OS - BusyBox wrapper for $cmd" >> "$1"/usr/bin/$cmd
        echo "busybox $cmd" >> "$1"/usr/bin/$cmd
        chmod +x "$1"/usr/bin/$cmd
    done
    cp /usr/bin/python3 "$1"/usr/bin/python3
    ln -s "$1"/usr/bin/python3 "$1"/usr/bin/python
    echo "Note: by default the auto-generated BusyBox-based Babies OS is installed."
    echo "Binaries from your system were copied from the system to the root."
    echo "Append --no-busybox to any future create commands to install the root without any binaries."
    echo "Please note the root won't work out of the box and binaries will need to be copied manually."
}

function runroot() {
    sudo -kp "babies: Type %u's password: " chroot ~/.babies/roots/"$1" $2
}

if [[ $1 == "create" ]]; then
  create $2
elif [[ $1 == "run" ]]; then
  runroot $2 $3
elif [[ $1 == "" ]] || [[ $1 == "help" ]]; then
  echo "Usage: $0 {create NAME [--no-busybox]|run NAME}"
  echo
  echo "Commands:"
  echo "  create      Create a new root with the chosen name"
  echo "  run         Run a command in a root, or a shell if nothing is specified"
else
  echo "Invalid command :("
  echo "Use this and learn: $0 help"
fi
