docker build -t georgebaptista/kubectl-proxy .
docker push georgebaptista/kubectl-proxy

Don't forget to make kubectl-proxy.sh executable, eg
`RUN chmod 700 /kubectl-proxy.sh`
