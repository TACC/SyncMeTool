#!/usr/bin/env bash
# -*- shell-script -*-
SCRIPT_NAME="${BASH_SOURCE[0]:-${(%):-%x}}"
SCRIPT_DIR=${SCRIPT_NAME%/*}


if [ $SCRIPT_DIR = "." ]; then
  SCRIPT_DIR=$PWD
fi  

rm -rf $HOME/ww
mkdir -p $HOME/ww/lmod

cd $HOME/ww/lmod

function colorMsg ()
{
  local colorName="$1"
  local str="$2"
  local NONE=$'\033[0m'
  declare -A colorT=( [BLACK]=$'\033[1;30m'
           [RED]=$'\033[1;31m'
           [GREEN]=$'\033[1;32m'
           [YELLOW]=$'\033[1;33m'
           [BLUE]=$'\033[1;34m'
           [MAGENTA]=$'\033[1;35m'
           [CYAN]=$'\033[1;36m'
           [WHITE]=$'\033[1;37m' )
  local color="${colorT[$colorName]}"
  echo "${color}${str}${NONE}"
}

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
runThis "git clone --bare git@github.com:TACC/Lmod.git lmod.git"
runThis "cd lmod.git"

runThis "git worktree add ../main"
runThis "git worktree add ../testing"
runThis "git worktree add ../PR679"
runThis "tree -L 1 $HOME/ww/lmod"
runThis "git worktree list"


