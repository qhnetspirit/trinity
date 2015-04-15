#!/bin/bash
#
# This is an example of how to search for an interaction between
# two syscalls.   In the example below I was chasing an oops involving
# futex and another unknown syscall.
#
# I wanted to avoid execve, because it just slowed things down, and had
# already been ruled out.
#

OLDPATH=$(pwd)
TRINITY_PATH=${TRINITY_PATH:-$OLDPATH}
TRINITY_TMP=$(mktemp -d /tmp/trinity.XXXXXX)

check_tainted()
{
    if [ "$(cat /proc/sys/kernel/tainted)" != $TAINT ]; then
      echo ERROR: Taint flag changed $(cat /proc/sys/kernel/tainted)
      exit
    fi
}

chmod 755 $TRINITY_TMP
cd $TRINITY_TMP

TAINT=$(cat /proc/sys/kernel/tainted)

NR_CPUS=$(nproc)

while [ 1 ];
do


for sc in $($TRINITY_PATH/trinity -L | grep entrypoint | grep -v AVOID | awk '{ print $3 }' | sort -u)
do
  mkdir -p tmp.$i
  pushd tmp.$i

  if [ ! -f $TRINITY_PATH/trinity ]; then
    echo lost!
    pwd
    exit
  fi

  $TRINITY_PATH/trinity -q -l off -c futex -c $sc -x execve -C64 -N 1000000

  popd

  check_tainted

  chmod 755 $TRINITY_TMP

done

done
