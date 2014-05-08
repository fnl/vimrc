#!/bin/bash

# task file management for atea <https://github.com/pkamenarsky/atea>

home=`cd ~; pwd`
tdir="${home}/Dropbox/Work/tasks"

if [[ `pwd` =~ .*/(.*) ]]; then
  mkdir -p $tdir

  # update .atea configuration
  tasks="${tdir}/${BASH_REMATCH[1]}.tasks"
  echo "{:file \"${tasks}\"}" > ~/.atea

  if [[ $1 == -o ]]; then
    touch $tasks
    $EDITOR $tasks
  fi
else
  echo "not a directory"
fi
