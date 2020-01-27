#!/bin/bash

usage_show () {
  echo "
The following options are applicable for use:

-c <mount config file>

-u <user config file> - required

-s <source network folder>

-d <destination directory>

"
}

if [ $# = 0 ]; then
  SCRIPTPATH=$(cd ${0%/*} && pwd -P)
  echo "Load standart configuration files:
  * $SCRIPTPATH\cm-mount.conf
  * $SCRIPTPATH\cm-user.conf"
  source $SCRIPTPATH/cm-mount.conf
  source $SCRIPTPATH/cm-user.conf
fi

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

-u)	
  if [ -r "$2" ]; then
	source "$2"
	shift 2
  else
	echo "Unreadable user config file \"$2\"" 1>&2
    exit 1
  fi
;;

-s)
  if [ -r "$2" ]; then 
	SRC="$2"
  else 
	echo "Unreadable source network folder"
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

if [ ! $SRC ]; then
  echo "No source network folder specified" 1>&2
  usage_show
  exit 1
fi

if [ ! $DEST ]; then 
  echo "Mount destination directory not specified" 1>&2
  exit 1
fi

if [ ! $USER ]; then
  echo "Source folder user not set" 1>&2
  exit 1
fi

if [ ! $PASSWORD ]; then 
  echo "Source folder user password not set" 1>&2
  exit 1
fi

echo "Try mount $SRC folder to $DEST...
Username: $USER
"
/bin/mount -t cifs $SRC $DEST -o user=$USER,password=$PASSWORD