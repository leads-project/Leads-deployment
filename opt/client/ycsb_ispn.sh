#!/bin/sh

java -cp /opt/ycsb/core/lib/core-0.1.4.jar:"/opt/ycsb/infinispan-binding/lib/*":/opt/ycsb/infinispan-binding/conf/:/opt/ycsb/infinispan-binding/lib/ com.yahoo.ycsb.Client -load -db com.yahoo.ycsb.db.InfinispanClient -s -P workloads/workloada
