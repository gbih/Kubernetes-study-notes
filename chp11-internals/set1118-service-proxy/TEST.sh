#/bin/bash 
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "11.1.8 The role of Kubernetes Service Proxy"
echo $HR_TOP

echo "Create deployment from example at https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service/"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
echo $HR

echo "kubectl rollout status deployment hostnames -n=chp11-set1118"
kubectl rollout status deployment hostnames -n=chp11-set1118

# https://www.cyberciti.biz/faq/how-to-list-all-iptables-rules-in-linux/
# https://www.digitalocean.com/community/tutorials/how-to-list-and-delete-iptables-firewall-rules
# https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service/

echo $HR

echo "kubectl get all -n chp11-set1118 -L app"
kubectl get all -n chp11-set1118 -L app
echo ""

echo "kubectl get endpoints -n chp11-set1118"
kubectl get endpoints -n chp11-set1118

echo $HR

echo "kubectl get pods -n chp11-set1118 -o go-template='{{range .items}}{{.status.podIP}}{{"\n"}}{{end}}'"
kubectl get pods -n chp11-set1118 -o go-template='{{range .items}}{{.status.podIP}}{{"\n"}}{{end}}'

echo $HR

enter

echo "Check kube-proxy is running"
echo ""
echo "ps auxw | grep kube-proxy"
ps auxw | grep kube-proxy

enter

# https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service/

echo 'Kube-proxy can run in one of a few modes. In the log listed above, the line Using iptables Proxier indicates that kube-proxy is running in "iptables" mode. The most common other mode is "ipvs". The older "userspace" mode has largely been replaced by these.'

enter

echo "ps auxw | grep kubelet"
ps auxw | grep kubelet

enter



echo "sudo iptables-save | grep hostnames"
echo ""
echo "For each port of each Service, there should be 1 rule in KUBE-SERVICES and one KUBE-SVC-<hash> chain."
echo "For each Pod endpoint, there should be a small number of rules in that KUBE-SVC-<hash> and one KUBE-SEP-<hash> chain with a small number of rules in it."
echo "The exact rules will vary based on your exact config (including node-ports and load-balancers)."
echo ""

echo "sudo iptables-save | grep hostnames"
sudo iptables-save | grep hostnames

enter



echo "List Rules by Specification"
echo "To list out all of the active iptables rules by specification"
echo "List all IPv4 rules"
echo ""
echo "sudo iptables -S"
sudo iptables -S

enter

echo "List all IPv6 rules"
echo ""
echo "sudo ip6tables -S"
sudo ip6tables -S

enter

echo "List Rules as Tables"
echo "List all tables rules"
echo "Listing the iptables rules in the table view can be useful for comparing different rules against each other"
echo "This will output all of current rules sorted by chain"
echo ""

echo "sudo iptables -L INPUT"
sudo iptables -L INPUT

enter

echo "Style 2:"
echo "sudo iptables -L -v -n"
sudo iptables -L -v -n

enter

echo "Show Packet Counts and Aggregate Size"
echo "When listing iptables rules, it is also possible to show the number of packets, and the aggregate size of the packets in bytes, that matched each particular rule. This is often useful when trying to get a rough idea of which rules are matching against packets. To do so, simply use the -L and -v option together."

echo "sudo iptables -L INPUT -v"
sudo iptables -L INPUT -v

enter


echo "List all rules for INPUT tables"
echo ""
echo "sudo iptables -L INPUT -v -n"
sudo iptables -L INPUT -v -n
echo $HR
echo "sudo iptables -S INPUT"
sudo iptables -S INPUT

enter

# https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service/

echo 'Kube-proxy can run in one of a few modes. In the log listed above, the line Using iptables Proxier indicates that kube-proxy is running in "iptables" mode. The most common other mode is "ipvs". The older "userspace" mode has largely been replaced by these.'


enter

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

