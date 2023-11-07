#!/bin/bash

function bsudo() {
    sudo -kp "babies: Type %u's password: " $@ || command $@
}

function error() {
    echo -e "\033[0;31m[X] Error: $1\033[0m"
}

function create() {
    if [ $1 == "" ]; then
      error "Please specify the name of the root to create"
      return
    fi
    export BABIES_ROOT="$HOME/.babies/roots/$1"
    mkdir -p $BABIES_ROOT
    mkdir -p $BABIES_ROOT/usr/bin
    bsudo busybox --install $BABIES_ROOT/usr/bin
    cp /usr/bin/python3 $BABIES_ROOT/usr/bin/python3
    ln -s $BABIES_ROOT/usr/bin/python3 $BABIES_ROOT/usr/bin/python
    ln -s $BABIES_ROOT/usr/bin $BABIES_ROOT/bin
    echo "Note: by default the auto-generated BusyBox-based Babies OS is installed."
    echo "Binaries from your system were copied from the system to the root."
    echo "Append --no-busybox to any future create commands to install the root without any binaries."
    echo "Please note the root won't work out of the box and binaries will need to be copied manually."
}

function runroot() {
    bsudo chroot ~/.babies/roots/"$1" $2
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
