#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)

kubectl delete -f $FULLPATH --now --ignore-not-found
echo $HR

