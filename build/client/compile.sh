#!/bin/sh

INFINISPAN_HOME=/home/otrack/Unine/LEADS/code/infinispan
YCSB_HOME=/home/otrack/Unine/LEADS/code/ycsb

javac -source 1.6 -target 1.6 -cp ${YCSB_HOME}/core/lib/core-0.1.4.jar:"${INFINISPAN_HOME}/lib/*" InfinispanClient.java

