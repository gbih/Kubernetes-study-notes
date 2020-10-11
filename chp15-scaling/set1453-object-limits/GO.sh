#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "14.5.3 Limiting the number of objects that can be created"
echo $HR_TOP


echo "Get Services from the API server"

kubectl exec -it curl-restrictive -n=chp14-set1453 -- sh -c "while true; do curl http://kubia.chp14-set1453; done"

