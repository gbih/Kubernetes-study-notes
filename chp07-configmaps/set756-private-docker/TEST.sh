#!/bin/bash
. ~/src/COMMON/SETUP.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "kubectl apply -f $FULLPATH/set756-0-ns.yaml"
kubectl apply -f $FULLPATH/set756-0-ns.yaml

echo $HR

echo "Create a docker-registry Secret called mydockerhubsecret, and specify the Docker Hub username, password, and email."
echo "Input docker password:"
read dockerpassword
echo ""
echo "kubectl -n=chp07-set756 create secret docker-registry mydockerhubsecret --docker-username=georgebaptista --docker-password=\$dockerpassword --docker-email=george@omame.com"
kubectl -n=chp07-set756 create secret docker-registry mydockerhubsecret --docker-username=georgebaptista --docker-password=$dockerpassword --docker-email=george@omame.com
echo $HR

echo "Create pod using this docker-registry secret:"
echo "kubectl apply -f $FULLPATH/set756-2-pod-with-private-image.yaml"
kubectl apply -f $FULLPATH/set756-2-pod-with-private-image.yaml
echo $HR

echo "kubectl wait --for=condition=Ready=True pod/private-pod -n=chp07-set756 --timeout=10s"
kubectl wait --for=condition=Ready=True pod/private-pod -n=chp07-set756 --timeout=10s
echo $HR

echo "kubectl get pod/private-pod -n=chp07-set756"
kubectl get pod/private-pod -n=chp07-set756 --show-labels

echo "kubectl port-forward private-pod -n=chp07-set756 8888:8080 &"
kubectl port-forward private-pod -n=chp07-set756 8888:8080 &
echo ""

sleep 1

echo $HR

echo "Running jobs are:"
jobs

enter

echo "curl http://localhost:8888 -v"
curl http://localhost:8888 -v
echo $HR

echo "Kill port-forward process listening to port 8888"
echo "kill -9 \`sudo fuser 8888/tcp|xargs -n 1\`"
kill -9 `sudo fuser 8888/tcp|xargs -n 1`
sleep 1

echo $HR

echo "kubectl get events -n=chp07-set756"
kubectl get events -n=chp07-set756
echo $HR

echo "kubectl logs private-pod -n=chp07-set756"
kubectl logs private-pod -n=chp07-set756

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

