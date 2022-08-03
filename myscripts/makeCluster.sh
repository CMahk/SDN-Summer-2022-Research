#!/bin/bash
export PATH="$PATH:bin:onos/bin"

SSH_KEY=$(cut -d\  -f2 ~/.ssh/id_rsa.pub)
ONOS_IMAGE=onosproject/onos:2.7.0

echo "Setting up onos-$1"
docker container run --detach --name onos-$1 --hostname onos-$1 --restart=always $ONOS_IMAGE
docker exec -i onos-$1 /bin/bash -c "mkdir config; cat > config/cluster.json" < $HOME/config/cluster-$1.json
docker exec -it onos-$1 bin/onos-user-key sdn $SSH_KEY  >/dev/null 2>&1
docker exec -it onos-$1 bin/onos-user-password onos rocks >/dev/null 2>&1

function waitForStart {
    sleep 5
	echo "Waiting for onos-$1 startup..."
	ip=$(docker container inspect onos-$1 | grep \"IPAddress | cut -d: -f2 | sort -u | tr -d '", ')
	for t in {1..60}; do
		curl --fail -sS http://$ip:8181/onos/v1/applications --user onos:rocks 1>/dev/null 2>&1 && break;
		sleep 1;
	done
	onos $ip summary >/dev/null 2>&1
}

# Extract the IP addresses of the ONOS nodes
NEW=$(docker container inspect onos-$1 | grep \"IPAddress | cut -d: -f2 | sort -u | tr -d '", ')

waitForStart "$1"

echo "Activating applications..."

OC_COMMAND="app activate org.onosproject.openflow proxyarp layout fwd"

echo "Activating for onos-$1"
sudo ssh-keygen -f "/root/.ssh/known_hosts" -R "[$NEW]:8101"
ssh-keygen -f "/root/.ssh/known_hosts" -R "[$NEW]:8101"
sshpass -p "karaf" ssh -o StrictHostKeyChecking=no -p 8101 karaf@"$NEW" "$OC_COMMAND"