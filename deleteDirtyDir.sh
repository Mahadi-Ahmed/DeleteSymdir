#!/bin/bash
 # This script will remove directories & files that are NOT symlinked
 for x in ~/testDir_symlink/*; do
  if ! [ -L $x ]; then
    rm -rf $x
  fi
done