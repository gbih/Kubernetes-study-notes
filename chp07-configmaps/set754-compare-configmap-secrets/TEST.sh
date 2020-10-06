#!/bin/bash
. ~/src/COMMON/SETUP.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "kubectl apply -f $FULLPATH/set753-0-ns.yaml"
echo "kubectl apply -f $FULLPATH/set753-1-configmap-volume.yaml"
kubectl apply -f $FULLPATH/set753-0-ns.yaml
kubectl apply -f $FULLPATH/set753-1-configmap-volume.yaml
echo $HR

rm -f https.cert
rm -f https.key
rm -f foo

value=$(<set753-1-configmap-volume.yaml)
echo "$value"

enter

#value=$(<set753-2-fortune-pod-env-configmap.yaml)
#echo "$value"

#enter

echo "Generate the key"
echo "(may need to comment this out: RANDFILE = $ENV::HOME/.rnd from /etc/ssl/openssl.cnf)"
echo "openssl genrsa -out https.key 2048"
openssl genrsa -out https.key 2048
echo $HR


echo "Generate the certificate"
echo "openssl req -new -x509 -key https.key -out https.cert -days 3650 -subj /CN=www.kubia-example.com"
openssl req -new -x509 -key https.key -out https.cert -days 3650 -subj /CN=www.kubia-example.com 
echo $HR

echo "Create the dummy file 'foo' and make it contain the string 'bar'"
echo "echo bar > foo"
echo bar > foo
echo $HR


echo "Create a Secret from the three files."
echo 'kubectl -n=chp07-set753 create secret generic fortune-https \
--from-file=https.key \
--from-file=https.cert \
--from-file=foo'
kubectl -n=chp07-set753 create secret generic fortune-https \
--from-file=https.key \
--from-file=https.cert \
--from-file=foo


enter

echo "kubectl get secret fortune-https -n=chp07-set753 -o yaml"
kubectl get secret fortune-https -n=chp07-set753 -o yaml 

enter

echo "kubectl get configmap fortune-config -n=chp07-set753 -o yaml"
kubectl get configmap fortune-config -n=chp07-set753 -o yaml

enter

echo "kubectl delete ns chp07-set753"
kubectl delete ns chp07-set753


: <<'END_COMMENT'

enter

echo "See if it’s serving HTTPS traffic by opening a port-forward tunnel to the pod’s port 443 and using it to send a request to the server with curl"
echo ""

echo "kubectl port-forward fortune-https -n=chp07-set753 8443:443 &"
kubectl port-forward fortune-https -n=chp07-set753 8443:443 &
echo ""
#echo $HR

sleep 1 >> /dev/null
echo ""

enter

echo "Running jobs are:"
jobs
echo $HR


echo "curl https://localhost:8443 -k -v"
echo ""
curl https://localhost:8443 -k -v

enter

echo "ps ax | grep port-forward | awk -F ' ' '{print $1}' | xargs sudo kill -9"
ps ax | grep port-forward | awk -F ' ' '{print $1}' | xargs sudo kill -9


echo $HR
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
END_COMMENT
