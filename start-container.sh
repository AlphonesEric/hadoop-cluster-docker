#!/bin/bash

# the default node number is 3
N=${1:-2}


# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
		-p 9000:9000 \
		-p 8100:8100 \
		-p 8032:8032 \
		-v /hadoop:/jar \
                --name hadoop-master \
                --hostname hadoop-master \
                jdk8-hadoop-master &> /dev/null


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	sudo docker run -itd \
	                --net=hadoop \
			-p 50010:50010 \
			-p 50020:50020 \
			-p 50075:50075 \
			-p 8042:8042 \
			-p 9001:9000 \
			-v /hadoop:/jar \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                jdk8-hadoop-master &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it hadoop-master bash
