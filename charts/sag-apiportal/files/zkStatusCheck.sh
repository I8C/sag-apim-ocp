zr={{$.Values.zookeeper.replicas | int }}
ns=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}' | head -1)
echo "nameserver is ${ns}"
for i in $(seq 1 ${zr}); do
  for j in $(seq 1 12); do
    dnsStatus=$(nslookup {{$.Release.Name }}-zookeeper-$((i-1)).{{$.Release.Name }}-zookeeper ${ns} | grep Address | awk 'END{print N,$2}')
    if [ ! -z "${dnsStatus}" ]; then
       echo "DNS resolved to ${dnsStatus} ..."
       break
    fi
    echo "{{$.Release.Name }}-zookeeper-$((i-1)).{{$.Release.Name }}-zookeeper not yet resolved ... Retries left $((12-j)) ..."
    sleep 10
    if [ ${j} -eq 12 -a -z "${dnsStatus}" ];then
      echo "Restarting container"
      exit 1
    fi
  done
done
