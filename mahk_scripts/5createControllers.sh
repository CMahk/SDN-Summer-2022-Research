#!/bin/bash
export PATH="$PATH:bin:onos/bin"

SSH_KEY=$(cut -d\  -f2 ~/.ssh/id_rsa.pub)

cp -R ./mahk_config ../../config

# Create Atomix cluster using Atomix docker image
ATOMIX_IMAGE=atomix/atomix:3.1.5
for i in {1..3}; do
    echo "Setting up atomix-$i..."
    docker container run --detach --name atomix-$i --hostname atomix-$i \
        --restart=always -v /mydata/config/5_controllers:/atomix $ATOMIX_IMAGE \
        --config /atomix/atomix-$i.conf
done

# Create ONOS cluster using ONOS docker image
ONOS_IMAGE=onosproject/onos:2.7.0
for i in {1..5}; do
    echo "Setting up onos-$i..."
    docker container run --detach --name onos-$i --hostname onos-$i --restart=always $ONOS_IMAGE
    docker exec -i onos-$i /bin/bash -c "mkdir config; cat > config/cluster.json" < /mydata/config/5_controllers/cluster-$i.json
    docker exec -it onos-$i bin/onos-user-key sdn $SSH_KEY  >/dev/null 2>&1
    docker exec -it onos-$i bin/onos-user-password onos rocks >/dev/null 2>&1
done

function waitForStart {
    sleep 5
    for i in {1..5}; do
        echo "Waiting for onos-$i startup..."
        ip=$(docker container inspect onos-$i | grep \"IPAddress | cut -d: -f2 | sort -u | tr -d '", ')
        for t in {1..60}; do
            curl --fail -sS http://$ip:8181/onos/v1/applications --user onos:rocks 1>/dev/null 2>&1 && break;
            sleep 1;
        done
        onos $ip summary >/dev/null 2>&1
    done
}

# Extract the IP addresses of the ONOS nodes
OC1=$(docker container inspect onos-1 | grep \"IPAddress | cut -d: -f2 | sort -u | tr -d '", ')
OC2=$(docker container inspect onos-2 | grep \"IPAddress | cut -d: -f2 | sort -u | tr -d '", ')
OC3=$(docker container inspect onos-3 | grep \"IPAddress | cut -d: -f2 | sort -u | tr -d '", ')
OC4=$(docker container inspect onos-4 | grep \"IPAddress | cut -d: -f2 | sort -u | tr -d '", ')
OC5=$(docker container inspect onos-5 | grep \"IPAddress | cut -d: -f2 | sort -u | tr -d '", ')
ONOS_INSTANCES="$OC1 $OC2 $OC3 $OC4 $OC5"

waitForStart

echo "Activating applications..."

OC_COMMAND="app activate org.onosproject.openflow proxyarp layout fwd"

echo "Activating for $OC1"
sudo ssh-keygen -f "/root/.ssh/known_hosts" -R "[$OC1]:8101"
ssh-keygen -f "/root/.ssh/known_hosts" -R "[$OC1]:8101"
sshpass -p "karaf" ssh -o StrictHostKeyChecking=no -p 8101 karaf@"$OC1" "$OC_COMMAND"

echo "Activating for $OC2"
sudo ssh-keygen -f "/root/.ssh/known_hosts" -R "[$OC2]:8101"
ssh-keygen -f "/root/.ssh/known_hosts" -R "[$OC2]:8101"
sshpass -p "karaf" ssh -o StrictHostKeyChecking=no -p 8101 karaf@"$OC2" "$OC_COMMAND"

echo "Activating for $OC3"
sudo ssh-keygen -f "/root/.ssh/known_hosts" -R "[$OC3]:8101"
ssh-keygen -f "/root/.ssh/known_hosts" -R "[$OC3]:8101"
sshpass -p "karaf" ssh -o StrictHostKeyChecking=no -p 8101 karaf@"$OC3" "$OC_COMMAND"

echo "Activating for $OC4"
sudo ssh-keygen -f "/root/.ssh/known_hosts" -R "[$OC4]:8101"
ssh-keygen -f "/root/.ssh/known_hosts" -R "[$OC4]:8101"
sshpass -p "karaf" ssh -o StrictHostKeyChecking=no -p 8101 karaf@"$OC4" "$OC_COMMAND"

echo "Activating for $OC5"
sudo ssh-keygen -f "/root/.ssh/known_hosts" -R "[$OC5]:8101"
ssh-keygen -f "/root/.ssh/known_hosts" -R "[$OC5]:8101"
sshpass -p "karaf" ssh -o StrictHostKeyChecking=no -p 8101 karaf@"$OC5" "$OC_COMMAND"
