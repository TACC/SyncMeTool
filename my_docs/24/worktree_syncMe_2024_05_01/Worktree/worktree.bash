#!/bin/zsh
# -*- shell-script -*-
SCRIPT_NAME="${BASH_SOURCE[0]:-${(%):-%x}}"
SCRIPT_DIR=${SCRIPT_NAME%/*}


if [ $SCRIPT_DIR = "." ]; then
  SCRIPT_DIR=$PWD
fi  

rm -rf $HOME/ww
mkdir -p $HOME/ww/lmod

cd $HOME/ww/lmod

runThis ()
{
  
  local cmd=$1
  echo 
  colorMsg RED "% $cmd"
  echo 
  eval $cmd
  #sleep 1
}

echo
echo "PWD: $PWD" ; # sleep 1
runThis "git clone --bare git@github.com:TACC/Lmod.git bare.git"
runThis "cd bare.git"

runThis "git worktree add ../main"
runThis "git worktree add ../testing"
runThis "git worktree add ../PR679"
runThis "tree -L 1 $HOME/ww/lmod"
runThis "git worktree list"


