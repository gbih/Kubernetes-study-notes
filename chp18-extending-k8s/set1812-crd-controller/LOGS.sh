!/bin/sh
clear

kubectl logs deployment.apps/website-controller -n=chp18-set1812 -c main

