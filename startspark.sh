#!/bin/bash
/opt/spark-2.1.0-bin-hadoop2.7/sbin/start-master.sh && /opt/spark-2.1.0-bin-hadoop2.7/sbin/start-slave.sh spark://localhost:7077
