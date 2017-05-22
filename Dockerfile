#FROM mldl-ipython

FROM ipoddaribm/powerai-examples

#Spark install
# Spark dependencies
ENV APACHE_SPARK_VERSION 2.1.0
ENV HADOOP_VERSION 2.7
WORKDIR /opt
RUN wget -q http://d3kbcqa49mib13.cloudfront.net/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN tar -xf spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
	
#Spark configuration
#COPY rootfs/spark/core-site.xml /opt/hadoop-2.7.0/etc/hadoop/core-site.xml
#COPY rootfs/spark/hdfs-site.xml /opt/hadoop-2.7.0/etc/hadoop/hdfs-site.xml
#COPY rootfs/spark/mapred-site.xml /opt/hadoop-2.7.0/etc/hadoop/mapred-site.xml
#COPY rootfs/spark/yarn-site.xml /opt/hadoop-2.7.0/etc/hadoop/yarn-site.xml
COPY rootfs/spark/spark-env.sh /opt/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/conf/spark-env.sh 
COPY rootfs/spark/spark-defaults.conf /opt/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/conf/spark-defaults.conf 
COPY rootfs/spark/sparkrc /opt/sparkrc 
COPY rootfs/spark/pyspark-notebook /opt/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/bin/pyspark-notebook
#COPY rootfs/spark/kernel.json /usr/local/share/jupyter/kernels/toree/kernel.json
RUN mkdir -p /opt/DL/spark
COPY rootfs/spark/examples /opt/DL/spark/examples

ADD conf.d/* /etc/supervisor/conf.d/

EXPOSE 8080 4040 8893

CMD ["/usr/bin/supervisord", "-n","-c" ,"/etc/supervisor/supervisord.conf"]
