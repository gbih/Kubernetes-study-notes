#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "14.5.3 Limiting the number of objects that can be created"
echo $HR_TOP


echo "Get Services from the API server"

kubectl exec -it curl-restrictive -n=chp15-set1513 -- sh -c "while true; do curl http://kubia.chp15-set1513; done"

