#Use PowerAI base image (from github.com)
FROM ipoddaribm/powerai-examples

#Spark install
# Spark dependencies
ENV APACHE_SPARK_VERSION 2.1.0
ENV HADOOP_VERSION 2.7
WORKDIR /opt
RUN wget -q http://d3kbcqa49mib13.cloudfront.net/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN tar -xf spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
	
#Spark configuration
COPY rootfs/spark/spark-env.sh /opt/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/conf/spark-env.sh 
COPY rootfs/spark/spark-defaults.conf /opt/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/conf/spark-defaults.conf 
COPY rootfs/spark/sparkrc /opt/sparkrc 
#COPY rootfs/spark/kernel.json /usr/local/share/jupyter/kernels/toree/kernel.json
RUN mkdir -p /opt/DL/spark
#Add Stocator (https://github.com/SparkTC/stocator) to the Spark JARS path
ADD stocator-1.0.9-SNAPSHOT-jar-with-dependencies.jar /opt/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/jars/

#Ports for Spark
EXPOSE 8080 4040 8893

#Install ibmseti & Scikit-learn
RUN pip install --upgrade pip && pip install ibmseti && pip install scikit-learn

#Install findspark (automatically make a SparkContext available)
RUN pip install --upgrade pip && pip install findspark

#Install Nano editor
RUN apt-get install -y nano

# To get spark master and slave running at startup
WORKDIR /root
RUN /bin/bash -c "rm -f /root/startjupyter.sh"
ADD startjupyter.sh /root/
ADD startspark.sh /root/ 
ADD conf.d/spark.conf /etc/supervisor/conf.d/

#add NIMBIX application
COPY AppDef.json /etc/NAE/AppDef.json
RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://api.jarvice.com/jarvice/validate

CMD ["/usr/bin/supervisord", "-n","-c" ,"/etc/supervisor/supervisord.conf"]
