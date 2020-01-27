#!/bin/bash

usage_show () {
  echo " ---
The following options are applicable for use:

-c <mount config file>

-d <destination directory>

"
}

while [ $# -gt 0 ]; do
case $1 in
-c)
  if [ -r "$2" ]; then
        source "$2"
    shift 2
  else
    echo "Unreadable mount config file \"$2\"" 1>&2
    exit 1
  fi
;;

-d)
  if [ -r "$2" ]; then
        DEST="$2"
  else
        echo "Unreadable destination directory"
        exit 1
  fi
;;

*)
  echo "Unknown Option \"$1\"" 1>&2
  usage_show
  exit 1
;;

esac
done

if [ $# = 0 ]; then
  SCRIPTPATH=$(cd ${0%/*} && pwd -P)
  source $SCRIPTPATH/cm-mount.conf
fi;

if [ ! $DEST ]; then
  echo "Mount destination directory not specified" 1>&2
  usage_show
  exit 1
fi
echo -e "Unmounting...\n"

/usr/bin/sudo /bin/umount $DEST
