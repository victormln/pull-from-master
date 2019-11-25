#!/bin/bash
# File: pull.sh
# Author: Víctor Molina (https://github.com/victormln)

# Color messages
ERROR='\033[0;31m'
OK='\033[0;32m'
WARNING='\033[1;33m'
NC='\033[0m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
ORANGE='\033[0;33m'
CYAN='\033[0;36m'
ACTUAL_DIR=$(dirname "${BASH_SOURCE[0]}")
IS_ABSOLUTE_PATH="true"
HAS_UNCOMMITED_FILES=0
CURRENT_BRANCH="master"

function is_an_absolute_path() {
  if [[ $1 == /* ]]; then IS_ABSOLUTE_PATH="true"; else IS_ABSOLUTE_PATH="false"; fi
}

function pull_from_master() {
  has_uncommited_files
  if [ $HAS_UNCOMMITED_FILES -ne 0 ]; then
    git stash
  fi
  get_current_branch
  if [ $CURRENT_BRANCH == "master" ]; then
    git pull origin master
  else
    get_current_branch
    git checkout master
    git pull origin master
    git checkout $CURRENT_BRANCH
  fi
  if [ $HAS_UNCOMMITED_FILES -ne 0 ]; then
    git stash pop >/dev/null 2>&1
  fi
  echo "==========================================="
}

function has_uncommited_files() {
  git diff-index --quiet HEAD --
  HAS_UNCOMMITED_FILES=$(echo $?)
}

function get_current_branch() {
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
}

function is_a_git_repository() {
  cd "$1" >/dev/null 2>&1 || exit
  if [ ! -e "$1/.git" ]; then
    echo -e "${ERROR}[ERROR]${NC} The directory: $1 its not a git repository"
  else
    echo -e "${OK}Pulling from: $1${NC}"
    echo "==========================================="
    pull_from_master $1
  fi
  cd "$ACTUAL_DIR" || exit
}

function get_all_paths() {
  input=$(dirname "${BASH_SOURCE[0]}")/repositories.txt
  while IFS= read -r repository_path; do
    is_an_absolute_path "$repository_path"
    if [ $IS_ABSOLUTE_PATH == "true" ]; then
      is_a_git_repository "$repository_path"
    else
      echo -e "${ERROR}[ERROR]${NC} The directory: $repository_path its not an absolute path"
    fi
  done <"$input"
}

get_all_paths
