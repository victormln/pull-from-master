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

function getAllPaths {
  echo "HOLA"
  while read REPOSITORY
  do
      echo "$REPOSITORY"
  done < $( dirname "${BASH_SOURCE[0]}" )/repositories.txt
}

getAllPaths
