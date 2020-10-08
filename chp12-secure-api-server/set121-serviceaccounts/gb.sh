#!/bin/bash

JWT='eyJhbGciOiJSUzI1NiIsImtpZCI6IkNtMk9DTDJOYVlZUHRQM0ZES1FINF9GS1gyUW5kS25nZkN6b2NmY2JNMU0ifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJjaHAxMi1zZXQxMjEiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlY3JldC5uYW1lIjoiZm9vLXRva2VuLTRraGhxIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImZvbyIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6ImI4OGRiYjI3LThlYmEtNGNmNS1hYzA4LTFjODkxMWUxMDYyZCIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpjaHAxMi1zZXQxMjE6Zm9vIn0.irdUqsrwVGm36sxEzStR52A0itbbwBaorVp5A4q0DAKCyWxxKQCcyAuyDa6_qXpetZ6Bb9q9AIzP1mbUCo76ZT4vNp15vGbtV8esyu4N2a840M8BoLTUSbfwG8Q_bDuI1IjnSZKHmNcJ5FHbeQuBH9sx2BmZYBaRtAL6DMxjTWmZhCPG72UuP6Lup12qcRrgiMCLioDMXc82MZYvzkIYN-kK-edgtfj9V5UmoNVnyrtWx_76JchtNuiAhSmyPiVYKFAwM3p9HdOwiH68LX0mD0r4s167_d6uSOpVa52gT0MM6UUE4zR-HoD8HQbHWktfvXVu9Sec0-yNlU_-oSB1mA'

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $JWT


echo "========="

IFS='.' read -ra ADDR <<< "$JWT"
JWT_HEADER=$(echo "${ADDR[0]}" | base64 -d 2> /dev/null)
JWT_PAYLOAD=$(echo "${ADDR[1]}" | base64 -d 2> /dev/null)
JWT_SIGNATURE="${ADDR[2]}"
echo "JWT Header:"
echo "${JWT_HEADER}" | jq '.'
echo "JWT Payload:"
echo "${JWT_PAYLOAD}" | jq '.'
echo "JWT Signature:"
echo "${JWT_SIGNATURE}"


#JWT_SUB=$(echo "$JWT_PAYLOAD" | jq -r .sub)
#JWT_EMAIL=$(echo "$JWT_PAYLOAD" | jq -r .email)
#echo "sub: $JWT_SUB email: $JWT_EMAIL"
