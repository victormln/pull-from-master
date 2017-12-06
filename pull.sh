#!/bin/bash
# Fichero: pull.sh
# Autor: Víctor Molina (https://github.com/victormln)

# Mensajes de color
ERROR='\033[0;31m'
OK='\033[0;32m'
WARNING='\033[1;33m'
NC='\033[0m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
ORANGE='\033[0;33m'
CYAN='\033[0;36m'
ACTUALDIR=$( dirname "${BASH_SOURCE[0]}" )
ITSABSOLUTEPATH="true"
HASUNCOMMITEDFILES=0
CURRENTBRANCH="master"

function checkIfItIsAbsolutePath {
  if [[ $1 == /* ]]; then ITSABSOLUTEPATH="true"; else ITSABSOLUTEPATH="false"; fi
}

function pullFromMaster {
  checkIfHasUnCommitedFiles
  if [ $HASUNCOMMITEDFILES -ne 0 ]
  then
    git stash
  fi
  getCurrentBranch
  if [ $CURRENTBRANCH == "master" ]
  then
    git pull origin master
    branch="master"
  else
    getCurrentBranch
    git checkout master
    git pull origin master
    git checkout $CURRENTBRANCH
  fi
  if [ $HASUNCOMMITEDFILES -ne 0 ]
  then
    git stash pop > /dev/null 2>&1
  fi
  echo "==========================================="
}

function checkIfHasUnCommitedFiles {
  git diff-index --quiet HEAD --
  HASUNCOMMITEDFILES=$(echo $?)
}

function getCurrentBranch {
  CURRENTBRANCH=$(git rev-parse --abbrev-ref HEAD)
}

function checkIfItsGitRepository {
  cd "$1" > /dev/null 2>&1
  if [ ! -e "$1/.git" ];
  then
    echo -e "${ERROR}[ERROR]${NC} El directorio: $1 no es un repositorio git"
  else
    echo -e "${OK}Actualizando: $1${NC}"
    echo "==========================================="
    pullFromMaster $1
  fi
  cd "$ACTUALDIR"
}

function getAllPaths {
  while read REPOSITORYPATH
  do
      checkIfItIsAbsolutePath $REPOSITORYPATH
      if [ $ITSABSOLUTEPATH == "true" ]
      then
        checkIfItsGitRepository "$REPOSITORYPATH"
      else
        echo -e "${ERROR}[ERROR]${NC} El directorio: $REPOSITORYPATH no es una ruta absoluta"
      fi
  done < $( dirname "${BASH_SOURCE[0]}" )/repositories.txt
}

getAllPaths
