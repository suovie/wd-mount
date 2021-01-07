#!/bin/bash

unset -v PASSWORD # make sure it's not exported
set +o allexport  # make sure variables are not automatically exported

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TAR=$1;

if ! [ -b "$TAR" ]; then
    echo "error: you must an specify existing block drive"
    exit 1
fi

WORK_DIR=`mktemp -d -p "$DIR"`

if [[ ! "$WORK_DIR" || ! -d "$WORK_DIR" ]]; then
  echo "error: could not create temp dir"
  exit 1
fi

B_PASSWD=$WORK_DIR/password.bin

# deletes the temp directory
function cleanup {
    PASSWORD=00000000000000000000000000000000000000000
    rm -rf "$WORK_DIR"
}

# register the cleanup function to be called on the EXIT signal
trap cleanup EXIT

COOKPW_PY="$DIR/wd-decrypte/cookpw.py"

if ! [ -f "$COOKPW_PY" ]; then
    echo "warning: cannot find cookpw.py from submodule WD-Decrypte, using fallback lib."
    COOKPW_PY="$DIR/lib/cookpw.py"
fi

IFS= read -rsp 'Enter drive password: ' PASSWORD < /dev/tty
echo

python3 $COOKPW_PY $PASSWORD > $B_PASSWD

if ! [ -f "$B_PASSWD" ]; then
    echo "error: could not generate encoded password from cookpw.py"
    exit 1
fi

sg_raw -s 40 -i "$B_PASSWD" $TAR c1 e1 00 00 00 00 00 00 28 00

