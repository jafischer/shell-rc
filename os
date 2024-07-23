#!/bin/bash
# Note: the hash-bang above was only added so that my IDE knows this is a bash script. But this script must be
# sourced, not executed from the command line.

is_mac() {
  [[ $(uname) == "Darwin" ]]
}

is_linux() {
  [[ $(uname) == "Linux" ]]
}

is_wsl() {
  is_linux && [[ -d /mnt/c ]]
}

my_os() {
  if is_mac; then
    echo mac
  elif is_wsl; then
    echo wsl
  elif is_linux; then
    echo linux
  else
    echo unknown-os
  fi    
}
