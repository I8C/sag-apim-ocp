zr={{$.Values.zookeeper.replicas | int }}
er={{$.Values.elasticsearch.replicas | int }}
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
      echo "Restarting"
      exit 1
    fi
  done
   revzr=$((zr-i))
   for j in $(seq 1 12); do
    dnsStatus=$(nslookup {{$.Release.Name }}-zookeeper-$((revzr)).{{$.Release.Name }}-zookeeper ${ns} | grep Address | awk 'END{print N,$2}')
    if [ ! -z "${dnsStatus}" ]; then
       echo "DNS resolved to ${dnsStatus} ..."
       break
    fi
    echo "{{$.Release.Name }}-zookeeper-$((revzr)).{{$.Release.Name }}-zookeeper not yet resolved ... Retries left $((12-j)) ..."
    sleep 10
    if [ ${j} -eq 12 -a -z "${dnsStatus}" ];then
      echo "Restarting"
      exit 1
    fi
  done
done
for i in $(seq 1 ${er}); do
  for j in $(seq 1 12); do
    dnsStatus=$(nslookup {{$.Release.Name }}-elasticsearch-$((i))-0.{{$.Release.Name }}-elasticsearch ${ns} | grep Address | awk 'END{print N,$2}')
    if [ ! -z "${dnsStatus}" ]; then
       echo "DNS resolved to ${dnsStatus} ..."
       break
    fi
    echo "{{$.Release.Name }}-elasticsearch-$((i))-0.{{$.Release.Name }}-elasticsearch not yet resolved ... Retries left $((12-j)) ..."
    sleep 10
    if [ ${j} -eq 12 -a -z "${dnsStatus}" ];then
      echo "Restarting"
      exit 1
    fi
  done
  rever=$((er-i+1))
  for j in $(seq 1 12); do
    dnsStatus=$(nslookup {{$.Release.Name }}-elasticsearch-$((rever))-0.{{$.Release.Name }}-elasticsearch ${ns} | grep Address | awk 'END{print N,$2}')
    if [ ! -z "${dnsStatus}" ]; then
       echo "DNS resolved to ${dnsStatus} ..."
       break
    fi
    echo "{{$.Release.Name }}-elasticsearch-$((rever))-0.{{$.Release.Name }}-elasticsearch not yet resolved ... Retries left $((12-j)) ..."
    sleep 10
    if [ ${j} -eq 12 -a -z "${dnsStatus}" ];then
      echo "Restarting"
      exit 1
    fi
  done
done
