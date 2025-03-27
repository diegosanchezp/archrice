#!/bin/bash

TITLE="tesis-no-title"

opts=$(getopt -o ht: --long help,title: -n "$0" -- "$@")
eval set -- "$opts"

while true; do
  case $1 in
    -h|--help)
      echo "Description: Spawn alacritty terminals that execute a command when spawned"
      echo ""
      echo "Usage: $0 [options] [args]"
      echo ""
      echo "Options:"
      echo "  -h, --help        Show this help message"
      echo "  -t, --title TITLE Set the title of the alacritty window"
      exit 0
      ;;
    -t|--title)
      TITLE="$2"
      shift 2
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Invalid option: $1"
      exit 1
      ;;
  esac
done

alacritty --title "${TITLE:-Default Title}" --option "env = { tesisdev = \"True\", tcommand = \"$*\" }"
