#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "kubectl apply -f $FULLPATH/set756-0-ns.yaml"
kubectl apply -f $FULLPATH/set756-0-ns.yaml
echo $HR

echo "Create a docker-registry Secret called mydockerhubsecret, and specify the Docker Hub username, password, and email."
echo ""

echo $HR
echo "Input docker password:"
read dockerpassword
echo "kubectl -n=chp07-set756 create secret docker-registry mydockerhubsecret --docker-username=georgebaptista --docker-password=\$dockerpasswordd --docker-email=george@omame.com"

kubectl -n=chp07-set756 create secret docker-registry mydockerhubsecret --docker-username=georgebaptista --docker-password=$dockerpassword --docker-email=george@omame.com
echo ""

echo "For comparison, purposely create a docker-registry with bad credentials:"
echo ""
echo "kubectl -n=chp07-set756 create secret docker-registry mydockerhubsecret-bad --docker-username=georgebaptista --docker-password=bad --docker-email=george@omame.com"

kubectl -n=chp07-set756 create secret docker-registry mydockerhubsecret-bad --docker-username=georgebaptista --docker-password=bad --docker-email=george@omame.com
echo $HR


echo "kubectl apply -f $FULLPATH/"
kubectl apply -f $FULLPATH/
echo ""

echo "kubectl wait --for=condition=Ready=True pod/private-pod -n=chp07-756 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/private-pod -n=chp07-set756 --timeout=30s
echo $HR

enter

echo "kubectl get all -n=chp07-set756 -o wide"
kubectl get all -n=chp07-set756 -o wide --show-labels
echo $HR


echo "kubectl port-forward private-pod -n=chp07-set756 8888:8080 &"
kubectl port-forward private-pod -n=chp07-set756 8888:8080 &
echo ""

sleep 1 >> /dev/null

echo ""
echo "Running jobs are:"
jobs
echo $HR


enter

echo "curl http://localhost:8888 -v"
curl http://localhost:8888 -v
echo $HR

ps ax | grep port-forward | awk -F ' ' '{print $1}' | xargs sudo kill -9
#ps ax | grep 'client.config port-forward fortune-https' | awk -F ' ' '{print $1}' | xargs sudo kill -9

enter

echo "kubectl get events -n=chp07-set756"
kubectl get events -n=chp07-set756
echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

